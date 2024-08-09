import 'package:ai_chat/data/models/my_class_res.dart';
import 'package:ai_chat/data/providers/dio_provider.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../models/app_version_res.dart';

part 'api_repository.g.dart';

final apiRepositoryProvider = Provider<ApiRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return ApiRepository(dio, baseUrl: dotenv.get('BASE_URL_API'));
});

@RestApi()
abstract class ApiRepository {
  factory ApiRepository(Dio dio, {String baseUrl}) = _ApiRepository;

  @GET('/common/get-version')
  Future<AppVersionRes> getVersion({
    @Query('deviceType') int deviceType = 2,
    @Query('serviceType') int serviceType = 2,
  });

  @GET('/v1/myClass')
  @Headers({'accessToken': 'true'})
  Future<MyClassRes> myClass();
}
