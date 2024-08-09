import 'package:ai_chat/data/notifier/splash_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/dialog_error.dart';
import '../../widgets/dialog_update.dart';

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
        ref.read(splashNotifierProvider.notifier).finishLoading();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<SplashState>>(splashNotifierProvider,
        (previous, next) {
      next.when(
        data: (data) {
          if (data == SplashState.authenticated) {
            context.go('/');
          } else if (data == SplashState.unauthenticated) {
            context.go('/login');
          } else if (data == SplashState.versionUpdate) {
            showUpdateDialog(context);
          } else if (data == SplashState.versionError) {
            showErrorDialog(context);
          } else if (data == SplashState.error) {
            showErrorDialog(context);
          }
        },
        error: (error, stackTrace) {
          // Handle error state
        },
        loading: () {
          // Handle loading state if needed
        },
      );
    });

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
