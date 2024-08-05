import 'package:ai_chat/models/app_version_res.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

final apiDioProvider = Provider<Dio>((ref) {
  final dio = Dio()
    ..options = BaseOptions(baseUrl: 'https://dev-app-api.yanadoo.co.kr');
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    error: true,
    compact: true,
  ));
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(apiDioProvider);
  return ApiClient(dio);
});

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/common/get-version')
  Future<AppVersionRes> getVersion({
    @Query('deviceType') int deviceType = 2,
    @Query('serviceType') int serviceType = 1,
  });
}