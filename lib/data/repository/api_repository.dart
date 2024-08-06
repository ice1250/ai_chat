import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/api_interceptor.dart';
import '../api/logger_interceptor.dart';
import '../models/app_version_res.dart';

final apiRepositoryProvider = Provider((ref) {
  final dio = Dio()
    ..interceptors.add(LoggerInterceptor())
    ..interceptors.add(ApiInterceptor())
    ..options.baseUrl = dotenv.get('BASE_URL_API');
  return ApiRepository(ApiClient(dio));
});

class ApiRepository {
  final ApiClient apiClient;

  ApiRepository(this.apiClient);

  Future<AppVersionRes> getVersion() async {
    return await apiClient.getVersion();
  }

  Future<String> srrMainInfo(int series) async {
    Map<String, Object> body = {
      'series': series,
    };
    return await apiClient.srrMainInfo(body);
  }
}
