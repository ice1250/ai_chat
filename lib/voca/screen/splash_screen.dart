import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=kr.epopsoft.word';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('현재 버전의 앱은 접속할 수 없어요.'),
                Text('새로운 버전의 앱을 다운로드하세요.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                _launchURL();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                  onTap: () => _showDialog(context),
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
