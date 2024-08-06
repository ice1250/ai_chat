import 'package:ai_chat/constants/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as flutter_secure_storage;

class ApiInterceptor extends InterceptorsWrapper {
  final flutter_secure_storage.FlutterSecureStorage storage;

  ApiInterceptor({required this.storage});

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 요청 전처리
    // 예 : 헤더 추가, 토큰 갱신

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: accessTokenKey);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    } else if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: refreshTokenKey);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 응답 후처리
    // 예 : 응답 로깅, 에러 처리
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러가 발생했을 때 (status code)
    // 토큰을 재발급받는 시도를 하고, 토큰이 재발급되면
    // 다시 새로운 토큰을 요청한다.
    final refreshToken = await storage.read(key: refreshTokenKey);

    // refreshToken이 null이면 에러 반환
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;

    if (isStatus401) {
      // 기존의 refresh token으로 새로운 accessToken 발급 시도
      // 반드시 새로운 Dio 객체를 생성해야 함
      final dio = Dio();

      try {
        // TODO 여기서 Auth의 get-access-token API 를 호출해야 하는데.. 나중에 수정하자..
        final response = await dio.post(
          '${dotenv.get('BASE_URL_AUTH')}/auth/v2/sign-in/get-access-token',
          options: Options(
            headers: {
              'Authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = response.data['data']['accessToken'];

        final options = err.requestOptions;

        // 요청의 헤더에 새로 발급받은 accessToken으로 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        // secure storage도 update
        await storage.write(key: accessTokenKey, value: accessToken);

        // 원래 보내려던 요청 재전송
        final newResponse = await dio.fetch(options);

        return handler.resolve(newResponse);
      } on DioException catch (e) {
        // 새로운 Access Token임에도 에러가 발생한다면, Refresh Token마저도 만료된 것임
        // TODO 로그아웃 처리
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
