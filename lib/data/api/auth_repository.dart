import 'package:ai_chat/data/providers/dio_provider.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../models/token_res.dart';

part 'auth_repository.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(dio, baseUrl: dotenv.get('BASE_URL_AUTH'));
});

@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  @POST('/auth/v2/sign-in/get-token')
  Future<TokenRes> getToken(
    @Query('userId') String userId,
    @Query('password') String password, {
    @Query('deviceType') String deviceType = '2',
  });

  @POST('/auth/v2/sign-in/get-access-token')
  @Headers({'refreshToken': 'true'})
  Future<TokenRes> getAccessToken();
}
