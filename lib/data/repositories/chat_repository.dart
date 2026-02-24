import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/domain/repositories/ai_repository.dart';

/// A mock implementation of [AIRepository] that simulates streaming AI
/// responses without requiring a real API key.
class MockAIRepository implements AIRepository {
  static const _mockResponse = '''Here is a quick overview of **Dart streams**:

## What are Streams?

Streams provide a way to receive a **sequence of events** over time. They are perfect for handling:

- Asynchronous data sequences
- Real-time updates (e.g. WebSocket messages)
- File I/O operations

## Example

```dart
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}
```

## Comparison

| Feature       | Future        | Stream            |
|---------------|---------------|-------------------|
| Values        | Single        | Multiple          |
| Completion    | Once          | Ongoing           |
| Cancellation  | No            | Yes (subscription)|

> Streams are one of the most powerful primitives in Dart's async model.''';

  @override
  Stream<String> sendMessage(List<ChatMessage> history, String prompt) async* {
    final words = _mockResponse.split(' ');
    for (final word in words) {
      await Future.delayed(const Duration(milliseconds: 50));
      yield '$word ';
    }
  }

  @override
  Future<List<String>> fetchModels() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return ['mock-model-v1', 'mock-model-v2'];
  }
}
