import 'package:ai_chat/widgets/dialog_update.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

/// 스플래시 스크린
/// - 앱 강제업데이트 관련 로직
/// - 디바이스 권한 허용
/// - 푸시 허용
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          GestureDetector(
            child: const Text('start'),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
