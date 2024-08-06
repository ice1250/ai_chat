import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth_client.dart';
import '../models/token_res.dart';

final authRepositoryProvider = Provider((ref) {
  final dio = Dio()
    ..interceptors.add(LogInterceptor())
    ..options.baseUrl = dotenv.get('BASE_URL_AUTH');
  return AuthRepository(AuthClient(dio));
});

class AuthRepository {
  final AuthClient authClient;

  AuthRepository(this.authClient);

  Future<TokenRes> getToken(
    String deviceType,
    String userId,
    String password,
  ) async {
    return await authClient.getToken(userId, password);
  }

  Future<TokenRes> getAccessToken(
    String refreshToken,
  ) async {
    return await authClient.getAccessToken('Bearer $refreshToken');
  }
}
