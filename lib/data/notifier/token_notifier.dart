import 'package:ai_chat/data/models/token_res.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../const/data.dart';
import '../api/auth_repository.dart';

class TokenNotifier extends StateNotifier<TokenResBase?> {
  final AuthRepository authRepository;
  final FlutterSecureStorage storage;

  TokenNotifier({
    required this.authRepository,
    required this.storage,
  }) : super(null) {
    // 처음에는 로딩..

    // getToken();
  }

  Future<TokenResBase> login({
    required String id,
    required String password,
  }) async {
    state = TokenResLoading();

    final result = await authRepository.getToken(id, password);

    if (result.meta.code == 200 && result.data != null) {
      await storage.write(key: accessTokenKey, value: result.data!.accessToken);
      await storage.write(
          key: refreshTokenKey, value: result.data!.refreshToken);
      state = result;
      return result;
    } else {
      state = TokenResError(error: '로그인 실패');
      return Future.value(state);
    }
  }

  Future<TokenResBase> refreshToken() async {
    state = TokenResLoading();

    final result = await authRepository.getAccessToken();

    if (result.meta.code == 200 && result.data != null) {
      await storage.write(key: 'accessToken', value: result.data!.accessToken);
      await storage.write(
          key: 'refreshToken', value: result.data!.refreshToken);
      state = result;
      return result;
    } else {
      state = TokenResError(error: '토큰 갱신 실패');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = TokenResLogout();

    await Future.wait([
      storage.delete(key: accessTokenKey),
      storage.delete(key: refreshTokenKey),
    ]);
  }
}
