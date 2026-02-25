import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/data/models/provider.dart';
import 'package:ai_client_service/data/repositories/chat_repository.dart';
import 'package:ai_client_service/domain/repositories/ai_repository.dart';
import 'package:ai_client_service/presentation/providers/provider_config_provider.dart';
import 'package:ai_client_service/services/provider_factory.dart';

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// The active [AIRepository] implementation. Automatically rebuilds when the
/// provider configuration changes. Falls back to [MockAIRepository] when no
/// API key is configured for OpenAI.
final aiRepositoryProvider = Provider<AIRepository>((ref) {
  final config = ref.watch(providerConfigProvider);

  // Use mock when no API key is set for providers that need one
  if (config.type == ProviderType.openai && config.apiKey.trim().isEmpty) {
    return MockAIRepository();
  }

  return RepositoryFactory.create(config);
});

/// Exposes the [ChatNotifier] and its [ChatState] to the widget tree.
final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((
  ref,
) {
  return ChatNotifier(ref.watch(aiRepositoryProvider));
});

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Immutable snapshot of the chat conversation state.
class ChatState {
  const ChatState({this.messages = const [], this.isStreaming = false});

  final List<ChatMessage> messages;
  final bool isStreaming;

  ChatState copyWith({List<ChatMessage>? messages, bool? isStreaming}) {
    return ChatState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._repository) : super(const ChatState());

  final AIRepository _repository;
  final _uuid = const Uuid();
  StreamSubscription<String>? _activeSubscription;

  /// Load prior messages. Currently a no-op placeholder for future
  /// persistence integration.
  void loadHistory() {
    state = const ChatState();
  }

  /// Sends a user [prompt], appends the user message to state, then streams
  /// the assistant response token-by-token.
  Future<void> sendMessage(String prompt) async {
    // 1. Append user message.
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: const MessageRole.user(),
      content: prompt,
      timestamp: DateTime.now(),
      status: const MessageStatus.sent(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isStreaming: true,
    );

    // 2. Prepare a placeholder assistant message.
    final assistantId = _uuid.v4();
    final assistantMessage = ChatMessage(
      id: assistantId,
      role: const MessageRole.assistant(),
      content: '',
      timestamp: DateTime.now(),
      status: const MessageStatus.sending(),
    );

    state = state.copyWith(messages: [...state.messages, assistantMessage]);

    // 3. Stream tokens from the repository.
    final buffer = StringBuffer();

    try {
      _activeSubscription = _repository
          .sendMessage(state.messages, prompt)
          .listen(
            (token) {
              buffer.write(token);
              _updateAssistantMessage(
                assistantId,
                buffer.toString(),
                const MessageStatus.sending(),
              );
            },
            onDone: () {
              _updateAssistantMessage(
                assistantId,
                buffer.toString(),
                const MessageStatus.sent(),
              );
              state = state.copyWith(isStreaming: false);
              _activeSubscription = null;
            },
            onError: (Object error) {
              final errorMsg = error is Exception
                  ? error.toString().replaceFirst('Exception: ', '')
                  : error.toString();
              _updateAssistantMessage(
                assistantId,
                buffer.isEmpty
                    ? 'Error: $errorMsg'
                    : '${buffer.toString()}\n\n---\n**Error:** $errorMsg',
                MessageStatus.error(errorMsg),
              );
              state = state.copyWith(isStreaming: false);
              _activeSubscription = null;
            },
          );
    } catch (e) {
      final errorMsg = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
      _updateAssistantMessage(
        assistantId,
        'Error: $errorMsg',
        MessageStatus.error(errorMsg),
      );
      state = state.copyWith(isStreaming: false);
    }
  }

  /// Cancels an in-flight streaming response.
  void cancelStream() {
    _activeSubscription?.cancel();
    _activeSubscription = null;
    state = state.copyWith(isStreaming: false);
  }

  @override
  void dispose() {
    _activeSubscription?.cancel();
    super.dispose();
  }

  // ---- helpers ----

  void _updateAssistantMessage(
    String id,
    String content,
    MessageStatus status,
  ) {
    final updated = state.messages.map((m) {
      if (m.id == id) {
        return m.copyWith(content: content, status: status);
      }
      return m;
    }).toList();

    state = state.copyWith(messages: updated);
  }
}
