import 'package:flutter_test/flutter_test.dart';

import 'package:ai_client_service/data/repositories/chat_repository.dart';

void main() {
  late MockAIRepository repository;

  setUp(() {
    repository = MockAIRepository();
  });

  group('MockAIRepository', () {
    test('sendMessage yields a non-empty stream of string chunks', () async {
      final chunks = await repository.sendMessage([], 'hello').toList();

      expect(chunks, isNotEmpty);
      for (final chunk in chunks) {
        expect(chunk, isA<String>());
      }
    });

    test(
      'sendMessage concatenated chunks contain expected markdown elements',
      () async {
        final chunks = await repository.sendMessage([], 'hello').toList();
        final fullResponse = chunks.join('');

        // Verify the response contains key Markdown elements.
        expect(fullResponse, contains('##'));
        expect(fullResponse, contains('**'));
        expect(fullResponse, contains('```dart'));
        expect(fullResponse, contains('| Feature'));
      },
    );

    test('fetchModels returns the expected mock model list', () async {
      final models = await repository.fetchModels();

      expect(models, ['mock-model-v1', 'mock-model-v2']);
    });
  });
}
