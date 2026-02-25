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
// Session data
// ---------------------------------------------------------------------------

/// In-memory representation of a single chat session.
class ChatSessionData {
  ChatSessionData({
    required this.id,
    required this.title,
    required this.createdAt,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];

  final String id;
  String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  String get timeLabel {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inDays == 0 && now.day == createdAt.day) return 'Today';
    if (diff.inDays <= 1 && now.day - createdAt.day == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${createdAt.month}/${createdAt.day}';
  }
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Immutable snapshot of the chat conversation state.
class ChatState {
  const ChatState({
    this.messages = const [],
    this.isStreaming = false,
    this.sessions = const {},
    this.activeSessionId = 'new',
  });

  final List<ChatMessage> messages;
  final bool isStreaming;
  final Map<String, ChatSessionData> sessions;
  final String activeSessionId;

  /// Sessions sorted newest-first.
  List<ChatSessionData> get sortedSessions {
    final list = sessions.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isStreaming,
    Map<String, ChatSessionData>? sessions,
    String? activeSessionId,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      sessions: sessions ?? this.sessions,
      activeSessionId: activeSessionId ?? this.activeSessionId,
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

  /// Creates a new empty chat session.
  void newChat() {
    _activeSubscription?.cancel();
    _activeSubscription = null;
    state = state.copyWith(
      messages: [],
      isStreaming: false,
      activeSessionId: 'new',
    );
  }

  /// Switches to an existing session by [id].
  void switchSession(String id) {
    final session = state.sessions[id];
    if (session == null) return;
    _activeSubscription?.cancel();
    _activeSubscription = null;
    state = state.copyWith(
      messages: List.of(session.messages),
      isStreaming: false,
      activeSessionId: id,
    );
  }

  /// Deletes a session by [id].
  void deleteSession(String id) {
    final updated = Map<String, ChatSessionData>.from(state.sessions);
    updated.remove(id);
    // If deleting the active session, switch to new chat
    if (state.activeSessionId == id) {
      state = state.copyWith(
        sessions: updated,
        messages: [],
        isStreaming: false,
        activeSessionId: 'new',
      );
    } else {
      state = state.copyWith(sessions: updated);
    }
  }

  /// Load prior messages. Clears current messages for a fresh start.
  void loadHistory() {
    newChat();
  }

  /// Sends a user [prompt], appends the user message to state, then streams
  /// the assistant response token-by-token.
  Future<void> sendMessage(String prompt) async {
    // 1. If this is a new chat, create a session first.
    String sessionId = state.activeSessionId;
    Map<String, ChatSessionData> sessions = Map.from(state.sessions);

    if (sessionId == 'new') {
      sessionId = _uuid.v4();
      final title = prompt.length > 40
          ? '${prompt.substring(0, 40)}...'
          : prompt;
      sessions[sessionId] = ChatSessionData(
        id: sessionId,
        title: title,
        createdAt: DateTime.now(),
      );
    }

    // 2. Append user message.
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: const MessageRole.user(),
      content: prompt,
      timestamp: DateTime.now(),
      status: const MessageStatus.sent(),
    );

    final updatedMessages = [...state.messages, userMessage];

    // Sync to session
    final activeSession = sessions[sessionId];
    if (activeSession != null) {
      activeSession.messages
        ..clear()
        ..addAll(updatedMessages);
    }

    state = state.copyWith(
      messages: updatedMessages,
      isStreaming: true,
      sessions: sessions,
      activeSessionId: sessionId,
    );

    // 3. Prepare a placeholder assistant message.
    final assistantId = _uuid.v4();
    final assistantMessage = ChatMessage(
      id: assistantId,
      role: const MessageRole.assistant(),
      content: '',
      timestamp: DateTime.now(),
      status: const MessageStatus.sending(),
    );

    state = state.copyWith(messages: [...state.messages, assistantMessage]);

    // 4. Stream tokens from the repository.
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
              _syncSessionMessages();
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
              _syncSessionMessages();
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
      _syncSessionMessages();
      state = state.copyWith(isStreaming: false);
    }
  }

  /// Cancels an in-flight streaming response.
  void cancelStream() {
    _activeSubscription?.cancel();
    _activeSubscription = null;
    _syncSessionMessages();
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

  /// Copies current messages into the active session's message list.
  void _syncSessionMessages() {
    final sid = state.activeSessionId;
    if (sid == 'new') return;
    final session = state.sessions[sid];
    if (session == null) return;
    session.messages
      ..clear()
      ..addAll(state.messages);
  }
}
