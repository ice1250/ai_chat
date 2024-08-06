import 'package:ai_chat/data/api/api_client.dart';
import 'package:ai_chat/data/providers/secure_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_interceptor.dart';
import '../api/logger_interceptor.dart';

part 'api_client_provider.g.dart';

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final dio = Dio()
    ..interceptors.add(LoggerInterceptor())
    ..interceptors
        .add(ApiInterceptor(storage: ref.watch(secureStorageProvider)))
    ..options.baseUrl = dotenv.get('BASE_URL_API');

  return ApiClient(dio);
}
