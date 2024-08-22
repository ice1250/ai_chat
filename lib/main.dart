import 'package:ai_chat/screens/auth/login_screen.dart';
import 'package:ai_chat/screens/home/chat/chat_screen.dart';
import 'package:ai_chat/screens/home/home_screen.dart';
import 'package:ai_chat/screens/home/setting/setting_screen.dart';
import 'package:ai_chat/screens/home/voca/voca_detail_page.dart';
import 'package:ai_chat/screens/test/auto_dispose/auto_dispose_page.dart';
import 'package:ai_chat/screens/test/auto_dispose_family/auto_dispose_family_page.dart';
import 'package:ai_chat/screens/test/basic/basic_page.dart';
import 'package:ai_chat/screens/test/family/family_page.dart';
import 'package:ai_chat/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import 'screens/splash/splash_screen.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  /*runApp(ProviderScope(
    child: MaterialApp.router(
      routerConfig: _router,
    ),
  ));*/

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'setting',
          builder: (context, state) => const SettingScreen(),
        ),
        GoRoute(
          path: 'chat',
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          path: 'voca',
          builder: (context, state) => const VocaDetailPage(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: const [
            CustomButton(
              title: 'Provider',
              child: BasicPage(),
            ),
            CustomButton(
              title: 'AutoDisposeProvider',
              child: AutoDisposePage(),
            ),
            CustomButton(
              title: 'FamilyProvider',
              child: FamilyPage(),
            ),
            CustomButton(
              title: 'AutoDisposeFamilyProvider',
              child: AutoDisposeFamilyPage(),
            ),
          ],
        ),
      ),
    );
  }
}
