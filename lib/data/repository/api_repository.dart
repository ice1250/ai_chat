import '../api/api_client.dart';
import '../models/app_version_res.dart';

class ApiRepository {
  Future<AppVersionRes> getVersion({
    required ApiClient apiClient,
  }) async {
    return await apiClient.getVersion();
  }

  Future<String> srrMainInfo({
    required ApiClient apiClient,
    required int series,
  }) async {
    Map<String, Object> body = {
      'series': series,
    };
    return await apiClient.srrMainInfo(body);
  }
}
