import 'package:flutter_riverpod/flutter_riverpod.dart';

final autoDisposeHelloProvider = Provider.autoDispose<String>((ref) {
  print('[autoDisposeHelloProvider] create');
  ref.onDispose(() {
    print('[autoDisposeHelloProvider] onDispose');
  });
  return 'Hello';
});
