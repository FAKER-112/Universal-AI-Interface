import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/domain/repositories/ai_repository.dart';

/// Repository that talks to any OpenAI-compatible chat completions API.
///
/// Supports streaming responses via Server-Sent Events (SSE) and handles
/// common error codes (401, 429, 5xx).
class OpenAIRepository implements AIRepository {
  OpenAIRepository({
    required String baseUrl,
    required String apiKey,
    required String model,
    this.temperature = 0.7,
    this.maxTokens = 4096,
    this.topP = 1.0,
    this.frequencyPenalty = 0.0,
    this.presencePenalty = 0.0,
    String organization = '',
    int timeout = 30,
  }) : _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl,
       _model = model,
       _dio = Dio(
         BaseOptions(
           headers: {
             'Content-Type': 'application/json',
             'Authorization': 'Bearer $apiKey',
             if (organization.isNotEmpty) 'OpenAI-Organization': organization,
           },
           connectTimeout: Duration(seconds: timeout),
           receiveTimeout: const Duration(minutes: 5),
         ),
       );

  final String _baseUrl;
  final String _model;
  final Dio _dio;
  final double temperature;
  final int maxTokens;
  final double topP;
  final double frequencyPenalty;
  final double presencePenalty;

  @override
  Stream<String> sendMessage(List<ChatMessage> history, String prompt) async* {
    final messages = _buildMessages(history, prompt);

    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        '$_baseUrl/chat/completions',
        data: {
          'model': _model,
          'messages': messages,
          'stream': true,
          'temperature': temperature,
          'max_tokens': maxTokens,
          'top_p': topP,
          'frequency_penalty': frequencyPenalty,
          'presence_penalty': presencePenalty,
        },
        options: Options(responseType: ResponseType.stream),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }

    // Parse SSE stream: each line starts with "data: " and ends with
    // "data: [DONE]" when complete.
    final stream = response.data!.stream;
    final lineBuffer = StringBuffer();

    await for (final chunk in stream) {
      final text = utf8.decode(chunk);
      lineBuffer.write(text);

      // Process complete lines
      final raw = lineBuffer.toString();
      final lines = raw.split('\n');

      // Keep the last (potentially incomplete) segment in the buffer
      lineBuffer.clear();
      lineBuffer.write(lines.last);

      for (var i = 0; i < lines.length - 1; i++) {
        final line = lines[i].trim();

        if (line.isEmpty) continue;
        if (line == 'data: [DONE]') return;
        if (!line.startsWith('data: ')) continue;

        final jsonStr = line.substring(6);
        try {
          final json = jsonDecode(jsonStr) as Map<String, dynamic>;
          final choices = json['choices'] as List<dynamic>?;
          if (choices != null && choices.isNotEmpty) {
            final delta =
                (choices[0] as Map<String, dynamic>)['delta']
                    as Map<String, dynamic>?;
            final content = delta?['content'] as String?;
            if (content != null && content.isNotEmpty) {
              yield content;
            }
          }
        } catch (_) {
          // Skip malformed JSON lines
        }
      }
    }
  }

  @override
  Future<List<String>> fetchModels() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('$_baseUrl/models');
      final data = response.data!['data'] as List<dynamic>;
      return data
          .map((m) => (m as Map<String, dynamic>)['id'] as String)
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ---- helpers ----

  List<Map<String, dynamic>> _buildMessages(
    List<ChatMessage> history,
    String prompt,
  ) {
    final msgs = <Map<String, dynamic>>[];
    for (final m in history) {
      final role = switch (m.role) {
        MessageRoleUser() => 'user',
        MessageRoleAssistant() => 'assistant',
        MessageRoleSystem() => 'system',
      };

      if (m.content.isEmpty && m.role is MessageRoleAssistant) continue;

      if (m.attachments.isNotEmpty) {
        // Multimodal structure
        final contentArray = <Map<String, dynamic>>[];
        if (m.content.isNotEmpty) {
          contentArray.add({'type': 'text', 'text': m.content});
        }

        for (final att in m.attachments) {
          try {
            final file = File(att.path);
            if (!file.existsSync()) continue;

            final bytes = file.readAsBytesSync();
            final base64String = base64Encode(bytes);

            if (att.mimeType.startsWith('image/')) {
              contentArray.add({
                'type': 'image_url',
                'image_url': {
                  'url': 'data:${att.mimeType};base64,$base64String',
                },
              });
            } else {
              // If the provider supports other files via input, we'd add them here.
              // Currently defaulting to text injection for generic files if possible,
              // or waiting off standard definitions based on OpenAI's advanced specs.
              // For now, only images are sent as true multimodal blocks universally.
              contentArray.add({
                'type': 'text',
                'text': '[Attached File: ${att.name}, type: ${att.mimeType}]',
              });
            }
            // ignore: empty_catches
          } catch (_) {}
        }
        msgs.add({'role': role, 'content': contentArray});
      } else {
        // Standard text structure
        msgs.add({'role': role, 'content': m.content});
      }
    }
    return msgs;
  }

  Exception _mapDioError(DioException e) {
    if (e.response != null) {
      final code = e.response!.statusCode;
      final body = e.response!.data;
      String detail = '';
      if (body is Map<String, dynamic>) {
        final error = body['error'];
        if (error is Map<String, dynamic>) {
          detail = error['message'] as String? ?? '';
        }
      }
      return switch (code) {
        401 => Exception(
          'Authentication failed (401): Invalid API key. $detail',
        ),
        429 => Exception(
          'Rate limit exceeded (429): Please slow down. $detail',
        ),
        _ => Exception('API error ($code): $detail'),
      };
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Exception(
        'Connection failed: Could not reach the API at $_baseUrl. '
        'Check your network connection and base URL.',
      );
    }
    return Exception('Network error: ${e.message}');
  }
}
