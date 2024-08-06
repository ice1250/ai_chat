import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor extends InterceptorsWrapper {
  final FlutterSecureStorage storage;

  ApiInterceptor({required this.storage});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if(options.uri.path.contains('get-version')) {
      return handler.next(options);
    }
    // 요청 전처리
    // 예 : 헤더 추가, 토큰 갱신
    final pref = SharedPreferences.getInstance();
    pref.then((value) {
      options.headers['Authorization'] =
          'Bearer ${value.getString('access_token')}';
    });
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 응답 후처리
    // 예 : 응답 로깅, 에러 처리
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 에러 처리
    // 예 : 에러 로깅, 다시 시도
    super.onError(err, handler);
  }
}
