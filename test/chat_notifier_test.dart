import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:ai_client_service/data/datasources/chat_local_datasource.dart';
import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/data/models/isar_chat_session.dart';
import 'package:ai_client_service/data/models/isar_chat_message.dart';
import 'package:ai_client_service/data/models/isar_provider_config.dart';
import 'package:ai_client_service/data/repositories/chat_repository.dart';
import 'package:ai_client_service/presentation/providers/chat_provider.dart';

void main() {
  late ChatNotifier notifier;
  late Isar isar;
  late LocalDataSource localDb;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [IsarChatSessionSchema, IsarChatMessageSchema, IsarProviderConfigSchema],
      directory: '',
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
    );
    localDb = LocalDataSource(isar);
    notifier = ChatNotifier(MockAIRepository(), localDb);
  });

  tearDown(() async {
    notifier.dispose();
    await isar.close(deleteFromDisk: true);
  });

  group('ChatNotifier', () {
    test('initial state has no messages and is not streaming', () {
      expect(notifier.state.messages, isEmpty);
      expect(notifier.state.isStreaming, isFalse);
    });

    test('newChat resets state to empty', () {
      notifier.newChat();

      expect(notifier.state.messages, isEmpty);
      expect(notifier.state.isStreaming, isFalse);
    });

    test('sendMessage adds user and assistant messages to state', () async {
      // Fire the send -- it streams asynchronously via listen().
      notifier.sendMessage('hello');

      // Poll until the stream finishes rather than using a fixed delay.
      for (var i = 0; i < 200; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!notifier.state.isStreaming) break;
      }

      expect(
        notifier.state.isStreaming,
        isFalse,
        reason: 'Stream should have completed',
      );

      final messages = notifier.state.messages;
      expect(messages.length, 2);

      // First message is the user message.
      expect(messages[0].role, isA<MessageRoleUser>());
      expect(messages[0].content, 'hello');
      expect(messages[0].status, isA<MessageStatusSent>());

      // Second message is the assistant response.
      expect(messages[1].role, isA<MessageRoleAssistant>());
      expect(messages[1].content.trim(), isNotEmpty);
      expect(messages[1].status, isA<MessageStatusSent>());
    });

    test(
      'cancelStream stops streaming and sets isStreaming to false',
      () async {
        // Start sending -- don't await completion.
        notifier.sendMessage('hello');

        // Give the stream just enough time to start.
        await Future.delayed(const Duration(milliseconds: 120));
        expect(notifier.state.isStreaming, isTrue);

        notifier.cancelStream();
        expect(notifier.state.isStreaming, isFalse);
      },
    );
  });
}
