import 'package:ai_chat/screens/test/auto_dispose/auto_dispose_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoDisposePage extends ConsumerWidget {
  const AutoDisposePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hello = ref.watch(autoDisposeHelloProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoDisposeProvider'),
      ),
      body: Center(
        child: Text(
          hello,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
