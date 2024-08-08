import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/token_res.dart';
import '../../data/providers/token_notifier_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _navigateHome() {
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

  void _showErrorDialog() {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Please check your ID and password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tokenNotifierProvider);

    // FIXME 이거는 안좋은코드.. 라우터도 Notifier로 관리하도록 변경 필요!!!!
    if (state is TokenRes) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateHome();
      });
    } else if (state is TokenResError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: state is TokenResLoading
                  ? null
                  : () async {
                      await ref.read(tokenNotifierProvider.notifier).login(
                            id: _idController.text,
                            password: _passwordController.text,
                          );
                    },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
