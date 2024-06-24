import 'package:ai_chat/voca/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(
    const MaterialApp(
      // home: HomeScreen(),
      home: SplashScreen(),
    ),
  );
}
