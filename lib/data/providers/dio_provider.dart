import 'package:ai_chat/data/api/api_interceptor.dart';
import 'package:ai_chat/data/providers/secure_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(
    LogInterceptor(),
  );
  dio.interceptors.add(
    ApiInterceptor(storage: ref.watch(secureStorageProvider)),
  );

  return dio;
});
