import 'dart:async';

import 'package:ai_chat/data/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../const/data.dart';
import '../api/api_repository.dart';
import '../api/auth_repository.dart';
import '../providers/secure_storage_provider.dart';

part 'splash_notifier.g.dart';

enum SplashState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  versionUpdate,
  versionError,
  error,
}

@riverpod
class SplashNotifier extends _$SplashNotifier {
  final Completer<void> _loadingCompleter = Completer<void>();

  @override
  Future<SplashState> build() async {
    state = const AsyncData(SplashState.loading);
    await checkVersion();
    return state.value!;
  }

  void finishLoading() {
    _loadingCompleter.complete();
  }

  Future<void> checkVersion() async {
    final result = await ref.read(apiRepositoryProvider).getVersion();

    if (result.meta.code == 200 && result.data != null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      int v1Number = getExtendedVersionNumber(result.data!.version);
      int v2Number = getExtendedVersionNumber(packageInfo.version);

      if (v1Number > v2Number) {
        _event(SplashState.versionUpdate);
      } else {
        checkLogin();
      }
    } else {
      _event(SplashState.versionError);
    }
  }

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  Future<void> checkLogin() async {
    final authRepository = ref.read(authRepositoryProvider);
    final storage = ref.read(secureStorageProvider);

    final refreshToken = await storage.read(key: refreshTokenKey);
    if (refreshToken != null) {
      // 이 로직이 꼭 필요한건지??? 실제로 accessToken이 만료되었을때 interceptor 에서 갱신을 해주고 있는데 굳이 해야하나?
      await authRepository.getAccessToken().then(
        (value) {
          if (value.meta.code == 200 && value.data != null) {
            ref.read(setUserProvider.notifier).state = value.data!.user;
            _event(SplashState.authenticated);
          } else {
            _event(SplashState.unauthenticated);
          }
        },
      ).onError(
        (error, stackTrace) {
          if (error is DioException) {
            // Refresh 토큰이 만료되어도 서버에서 401 에러를 내려주지 않음..
            // 401 에러가 아니여도 토큰이 만료되었을 수 있음
            // 302 에러를 대신 내려주는지 테스트 해보았는데.. 302 에러는 url이 잘못 된 경우에도 내려옴..
            // 결론은 서버에서 수정해 주지 않는 이상 그냥 토큰이 만료되었다고 판단하고 로그인 화면으로 이동

            /*if (error.response?.statusCode == 401 || error.response?.statusCode == 302) {
              _event(SplashState.unauthenticated);
            } else {
              _event(SplashState.error);
            }*/
            _event(SplashState.unauthenticated);
          } else {
            _event(SplashState.error);
          }
        },
      );
    } else {
      _event(SplashState.unauthenticated);
    }
  }

  Future<void> _event(SplashState event) async {
    await _loadingCompleter.future;
    state = AsyncData(event);
  }
}
