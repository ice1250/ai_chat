import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../const/data.dart';
import '../api/auth_repository.dart';
import '../models/token_res.dart';
import '../providers/secure_storage_provider.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<TokenRes?> build() => Future.value(null);

  Future<TokenRes> login({
    required String id,
    required String password,
  }) async {
    state = const AsyncLoading();

    final authRepository = ref.read(authRepositoryProvider);
    final storage = ref.read(secureStorageProvider);

    final result = await authRepository.getToken(id, password);
    if (result.meta.code == 200 && result.data != null) {
      await storage.write(key: accessTokenKey, value: result.data!.accessToken);
      await storage.write(
          key: refreshTokenKey, value: result.data!.refreshToken);
      state = AsyncData(result);
      return result;
    } else {
      state = AsyncError(result.meta.message, StackTrace.current);
      return Future.error(result.meta.message);
    }
  }

  Future<TokenRes> refreshToken() async {
    state = const AsyncValue.loading();

    final authRepository = ref.read(authRepositoryProvider);
    final storage = ref.read(secureStorageProvider);

    final result = await authRepository.getAccessToken();
    print('result 1');
    if (result.meta.code == 200 && result.data != null) {
      print('result 2');
      await storage.write(key: accessTokenKey, value: result.data!.accessToken);
      await storage.write(
          key: refreshTokenKey, value: result.data!.refreshToken);
      state = AsyncValue.data(result);
      return result;
    } else {
      print('result 3');
      state = AsyncError(result.meta.message, StackTrace.current);
      return Future.error(result.meta.message);
    }
  }

  Future<bool> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
    state = const AsyncValue.data(null);
    return true;
  }

  Future<bool> hasToken() async {
    final storage = ref.read(secureStorageProvider);
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);

    if (accessToken != null && refreshToken != null) {
      return true;
    } else {
      return false;
    }
  }
}
