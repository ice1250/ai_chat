import 'package:ai_chat/models/token_res.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio) = _AuthClient;

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
