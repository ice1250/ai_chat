import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatRepository {
  final _dio = Dio();

  Future<String> sendMessage({
    required String message,
  }) async {
    Map<String, dynamic>? param = {
      "id": dotenv.get('PARAM_ID'),
      "user": dotenv.get('PARAM_USER'),
      "promptType": "LAURA_PARKER",
      "message": message,
    };
    final resp = await _dio.post(
      dotenv.get('URL_CONVERSATION'),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: param,
    );
    return resp.data;
  }

  Future<String> translate({
    required String message,
  }) async {
    Map<String, dynamic>? param = {
      "user": dotenv.get('PARAM_USER'),
      "message": message,
    };
    final resp = await _dio.post(
      dotenv.get('URL_TRANSLATE'),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: param,
    );
    return resp.data;
  }
}
