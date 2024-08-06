import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showErrorDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('알림'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('에러가 발생했습니다.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _killApp();
            },
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}

void _killApp() {
  // finish app
  SystemNavigator.pop();
}
