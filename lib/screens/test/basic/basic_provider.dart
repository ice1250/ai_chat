import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider 는 항상 Global final 변수여야 한다.
final helloProvider = Provider<String>((ref) {
  ref.onDispose(() {
    print('[HelloProvider] onDispose');
  });
  return 'Hello';
});

final worldProvider = Provider<String>((ref) {
  ref.onDispose(() {
    print('[WorldProvider] onDispose');
  });
  return 'World';
});

