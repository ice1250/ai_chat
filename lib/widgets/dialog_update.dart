import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showUpdateDialog(BuildContext context) async {
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
            onPressed: () {
              Navigator.of(context).pop();
              _launchURL();
            },
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}

Future<void> _launchURL() async {
  const url = 'https://play.google.com/store/apps/details?id=kr.epopsoft.word';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
