import 'package:ai_chat/models/token_res.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio()
    ..options = BaseOptions(baseUrl: 'https://dev-auth.yanadoo.co.kr');
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    error: true,
    compact: true,
  ));
  return dio;
});

final authClientProvider = Provider<AuthClient>((ref) {
  final dio = ref.watch(authDioProvider);
  return AuthClient(dio);
});

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST('/auth/v2/sign-in/get-token')
  Future<TokenRes> getToken(
    @Query('userId') String userId,
    @Query('password') String password, {
    @Query('deviceType') String deviceType = '2',
  });

  @POST('/auth/v2/sign-in/get-access-token')
  Future<TokenRes> getAccessToken(
    @Header('Authorization') String refreshToken,
  );
}
