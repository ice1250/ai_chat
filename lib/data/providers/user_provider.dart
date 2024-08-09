import 'package:ai_chat/data/models/token_res.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setUserProvider = StateProvider<User?>((ref) => null);

final getUserProvider =
    StateProvider<User?>((ref) => ref.watch(setUserProvider));
