import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/domain/repositories/ai_repository.dart';

/// Repository for local Ollama instances.
///
/// Ollama uses NDJSON streaming (one JSON object per line) rather than SSE.
/// Each line contains `{"message":{"content":"..."},"done":false}`.
class OllamaRepository implements AIRepository {
  OllamaRepository({required String baseUrl, required String model})
    : _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl,
      _model = model,
      _dio = Dio(
        BaseOptions(
          headers: {'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

  final String _baseUrl;
  final String _model;
  final Dio _dio;

  @override
  Stream<String> sendMessage(List<ChatMessage> history, String prompt) async* {
    final messages = _buildMessages(history, prompt);

    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        '$_baseUrl/api/chat',
        data: {'model': _model, 'messages': messages, 'stream': true},
        options: Options(responseType: ResponseType.stream),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    // Parse NDJSON: one JSON object per line
    final stream = response.data!.stream;
    final lineBuffer = StringBuffer();

    await for (final chunk in stream) {
      final text = utf8.decode(chunk);
      lineBuffer.write(text);

      final raw = lineBuffer.toString();
      final lines = raw.split('\n');

      lineBuffer.clear();
      lineBuffer.write(lines.last);

      for (var i = 0; i < lines.length - 1; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        try {
          final json = jsonDecode(line) as Map<String, dynamic>;

          // Check for completion
          if (json['done'] == true) return;

          final message = json['message'] as Map<String, dynamic>?;
          final content = message?['content'] as String?;
          if (content != null && content.isNotEmpty) {
            yield content;
          }
        } catch (_) {
          // Skip malformed JSON
        }
      }
    }
  }

  @override
  Future<List<String>> fetchModels() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/api/tags',
      );
      final models = response.data!['models'] as List<dynamic>;
      return models
          .map((m) => (m as Map<String, dynamic>)['name'] as String)
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ---- helpers ----

  List<Map<String, String>> _buildMessages(
    List<ChatMessage> history,
    String prompt,
  ) {
    final msgs = <Map<String, String>>[];
    for (final m in history) {
      final role = switch (m.role) {
        MessageRoleUser() => 'user',
        MessageRoleAssistant() => 'assistant',
        MessageRoleSystem() => 'system',
      };
      if (m.content.isEmpty && m.role is MessageRoleAssistant) continue;
      msgs.add({'role': role, 'content': m.content});
    }
    return msgs;
  }

  Exception _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Exception(
        'Could not connect to Ollama at $_baseUrl. '
        'Make sure Ollama is running (ollama serve) and the URL is correct.',
      );
    }
    if (e.response != null) {
      final code = e.response!.statusCode;
      final body = e.response!.data;
      String detail = '';
      if (body is Map<String, dynamic>) {
        detail = body['error'] as String? ?? '';
      }
      return Exception('Ollama error ($code): $detail');
    }
    return Exception('Network error: ${e.message}');
  }
}
