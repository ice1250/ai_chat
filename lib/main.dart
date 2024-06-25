import 'package:ai_chat/screens/chat_screen.dart';
import 'package:ai_chat/screens/home_page.dart';
import 'package:ai_chat/screens/setting_page.dart';
import 'package:ai_chat/screens/voca/voca_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'screens/splash_screen.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/voca': (context) => const VocaDetailPage(),
        '/setting': (context) => const SettingPage(),
        '/chat': (context) => const ChatScreen(),
      },
    ),
  );
}
