import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final pref = SharedPreferences.getInstance();
    pref.then((value) {
      options.headers['Authorization'] =
          'Bearer ${value.getString('access_token')}';
    });
    return handler.next(options);
  }
}
