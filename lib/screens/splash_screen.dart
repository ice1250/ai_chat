import 'package:ai_chat/widgets/dialog_error.dart';
import 'package:ai_chat/widgets/dialog_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/app_version_res.dart';
import '../data/repository/api_repository.dart';
import '../data/repository/auth_repository.dart';

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
    AppVersionRes result = await ref.read(apiRepositoryProvider).getVersion();
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
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');
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
    final size = MediaQuery.sizeOf(context);
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                child: const Text('start'),
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                      onTap: () => showUpdateDialog(context),
                      child: Image.asset('assets/images/splash_image.png')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "버전 확인중...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: size.width * .7,
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
