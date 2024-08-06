import 'package:ai_chat/constants/const.dart';
import 'package:ai_chat/data/providers/api_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/providers/api_client_provider.dart';
import '../../data/providers/secure_storage_provider.dart';
import '../../data/repository/auth_repository.dart';
import '../../widgets/dialog_error.dart';
import '../../widgets/dialog_update.dart';

/// 스플래시 스크린
/// - 앱 강제업데이트 관련 로직
/// - 디바이스 권한 허용
/// - 푸시 허용
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // checkLogin();
        checkVersion();
      }
    });
  }

  Future<void> checkVersion() async {
    final result = await ref
        .read(apiRepositoryProvider)
        .getVersion(apiClient: ref.read(apiClientProvider));

    if (result.meta.code == 200 && result.data != null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      int v1Number = getExtendedVersionNumber(result.data!.version);
      int v2Number = getExtendedVersionNumber(packageInfo.version);

      if (v1Number > v2Number) {
        if (context.mounted) showUpdateDialog(context);
      } else {
        checkLogin();
      }
    } else {
      if (context.mounted) showErrorDialog(context);
    }
  }

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  void navigateToHome() {
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

  void navigateToLogin() {
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  void checkLogin() async {
    final storage = ref.read(secureStorageProvider);
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);
    if (accessToken != null && refreshToken != null) {
      final authRepository = ref.read(authRepositoryProvider);
      authRepository.getAccessToken(refreshToken).then((value) {
        if (value.meta.code == 200) {
          navigateToHome();
        } else {
          navigateToLogin();
        }
      });
    } else {
      navigateToLogin();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final versionResult = ref.read(getVersionProvider(
    //     apiClient: ref.read(apiClientProvider),
    //     apiRepository: ref.read(apiRepositoryProvider)));

    // versionResult.when(
    //   data: (data) {
    //     print('데이터 가져오기 성공');
    //   },
    //   error: (error, stackTrace) {
    //     print('데이터 가져오기 실패 $error');
    //   },
    //   loading: () {
    //     print('로딩중');
    //   },
    // );

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: child,
              );
            },
            child: Image.asset(
              'assets/images/splash_bg.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
