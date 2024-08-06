import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

class ChatRepository {
  final _dio = Dio();

  ChatRepository() {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

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

  Future<Uint8List> audio({
    required String message,
  }) async {
    Map<String, dynamic>? param = {
      "model": "tts-1",
      "voice": "alloy",
      "response_format": "mp3",
      "input": message,
    };
    final resp = await _dio.post(
      dotenv.get('URL_AUDIO'),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.bytes,
      ),
      data: param,
    );
    return resp.data;
  }

  Future<String> transcriptions({
    required String audioPath,
  }) async {
    final audioBytes = await File(audioPath).readAsBytes();
    final audioMultipartFile = MultipartFile.fromBytes(
      audioBytes.buffer.asUint8List(),
      filename: audioPath.split('/').last, // Use the file name from the path
      contentType:
          MediaType('audio', 'wav'), // Use the correct MIME type for your file
    );
    FormData formData = FormData.fromMap({
      "file": audioMultipartFile,
      "model": "whisper-1",
      "language": "en",
    });
    final resp = await _dio.post(
      dotenv.get('URL_TRANSCRIPTIONS'),
      options: Options(
        headers: {
          'Authorization': 'Bearer ${dotenv.get('OPEN_API_KEY')}',
          'Content-Type': 'multipart/form-data',
        },
        contentType: 'multipart/form-data',
      ),
      data: formData,
    );
    return resp.data['text'];
  }
}
