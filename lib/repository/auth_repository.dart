import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth_client.dart';
import '../models/token_res.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(ref));

class AuthRepository {
  final ProviderRef ref;

  AuthRepository(this.ref);

  Future<TokenRes> getToken(
    String deviceType,
    String userId,
    String password,
  ) async {
    final authClient = ref.watch(authClientProvider);
    return await authClient.getToken(userId, password);
  }

  Future<TokenRes> getAccessToken(
    String refreshToken,
  ) async {
    final authClient = ref.watch(authClientProvider);
    return await authClient.getAccessToken('Bearer $refreshToken');
  }
}
