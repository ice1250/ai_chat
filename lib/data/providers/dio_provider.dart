import 'package:ai_chat/data/api/api_interceptor.dart';
import 'package:ai_chat/data/api/logger_interceptor.dart';
import 'package:ai_chat/data/providers/secure_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.addAll([
    LoggerInterceptor(),
    ApiInterceptor(storage: ref.watch(secureStorageProvider)),
  ]);
  return dio;
});
