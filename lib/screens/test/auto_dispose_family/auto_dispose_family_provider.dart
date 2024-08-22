import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter {
  final int count;

  Counter({required this.count});

  @override
  String toString() {
    return 'Counter{count: $count}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Counter && other.count == count;
  }

  @override
  int get hashCode {
    return count.hashCode;
  }
}

final counterProvider =
    Provider.autoDispose.family<int, Counter>((ref, counter) {
  ref.onDispose(() {
    print('[counterProvider][$counter] onDispose');
  });
  return counter.count;
});

final autoDisposeFamilyHelloProvider =
    Provider.autoDispose.family<String, String>((ref, name) {
  print('[autoDisposeFamilyHelloProvider] create');
  ref.onDispose(() {
    print('[autoDisposeFamilyHelloProvider] onDispose');
  });
  return 'Hello $name';
});
