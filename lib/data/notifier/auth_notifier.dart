import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../const/data.dart';
import '../api/auth_repository.dart';
import '../models/token_res.dart';
import '../providers/secure_storage_provider.dart';
import '../providers/user_provider.dart';

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
      ref.read(setUserProvider.notifier).state = result.data!.user;

      state = AsyncData(result);
      return result;
    } else {
      state = AsyncError(result.meta.message, StackTrace.current);
      return Future.error(result.meta.message);
    }
  }

  Future<bool> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
    state = const AsyncValue.data(null);
    ref.read(setUserProvider.notifier).state = null;
    return true;
  }
}
