import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../models/app_version_res.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @GET('/api/common/get-version')
  Future<AppVersionRes> getVersion({
    @Query('deviceType') int deviceType = 2,
    @Query('serviceType') int serviceType = 2,
  });

  @POST('/api/srr/main/info')
  Future<String> srrMainInfo(@Body() Map<String, Object> body);
}
