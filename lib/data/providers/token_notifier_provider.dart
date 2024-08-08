import 'package:ai_chat/data/models/token_res.dart';
import 'package:ai_chat/data/notifier/token_notifier.dart';
import 'package:ai_chat/data/providers/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth_repository.dart';

final tokenNotifierProvider =
    StateNotifierProvider<TokenNotifier, TokenResBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return TokenNotifier(authRepository: authRepository, storage: storage);
});
