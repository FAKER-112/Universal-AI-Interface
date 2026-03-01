import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:ai_client_service/data/datasources/chat_local_datasource.dart';
import 'package:ai_client_service/data/models/chat_attachment.dart';
import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/data/models/chat_session.dart';
import 'package:ai_client_service/data/models/provider.dart';
import 'package:ai_client_service/data/repositories/chat_repository.dart';
import 'package:ai_client_service/domain/repositories/ai_repository.dart';
import 'package:ai_client_service/main.dart';
import 'package:ai_client_service/presentation/providers/provider_config_provider.dart';
import 'package:ai_client_service/services/provider_factory.dart';

import 'package:ai_client_service/data/models/council_member.dart';
import 'package:ai_client_service/domain/usecases/llm_council_usecase.dart';
import 'package:ai_client_service/presentation/providers/llm_council_provider.dart';

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

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((
  ref,
) {
  final repository = ref.watch(aiRepositoryProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  final councilMembers = ref.watch(councilMembersProvider);
  final councilUsecase = LLMCouncilUsecase(repository);
  return ChatNotifier(
    repository,
    localDataSource,
    councilUsecase,
    councilMembers,
  );
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
    this.providerId = '',
    this.modelName = '',
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];

  final String id;
  String title;
  final DateTime createdAt;
  final String providerId;
  final String modelName;
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
    this.isLoading = true,
  });

  final List<ChatMessage> messages;
  final bool isStreaming;
  final Map<String, ChatSessionData> sessions;
  final String activeSessionId;
  final bool isLoading;

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
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      sessions: sessions ?? this.sessions,
      activeSessionId: activeSessionId ?? this.activeSessionId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(
    this._repository,
    this._localDb,
    this._councilUsecase,
    this._councilMembers,
  ) : super(const ChatState()) {
    _loadSessionsFromDb();
  }

  final AIRepository _repository;
  final LocalDataSource _localDb;
  final LLMCouncilUsecase _councilUsecase;
  final List<CouncilMember> _councilMembers;
  final _uuid = const Uuid();
  StreamSubscription<String>? _activeSubscription;

  /// Loads all saved sessions from the local database.
  Future<void> _loadSessionsFromDb() async {
    final dbSessions = await _localDb.getAllSessions();
    final sessionsMap = <String, ChatSessionData>{};

    for (final s in dbSessions) {
      sessionsMap[s.id] = ChatSessionData(
        id: s.id,
        title: s.title,
        createdAt: s.createdAt,
        providerId: s.providerId,
      );
    }

    state = state.copyWith(sessions: sessionsMap, isLoading: false);
  }

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

  /// Switches to an existing session by [id], loading messages from DB.
  Future<void> switchSession(String id) async {
    final session = state.sessions[id];
    if (session == null) return;
    _activeSubscription?.cancel();
    _activeSubscription = null;

    // Load messages from Isar.
    final messages = await _localDb.getMessages(id);
    session.messages
      ..clear()
      ..addAll(messages);

    state = state.copyWith(
      messages: List.of(messages),
      isStreaming: false,
      activeSessionId: id,
    );
  }

  /// Regenerates the response for a given assistant message, removing it
  /// and any subsequent messages, and resending the preceding user prompt.
  Future<void> regenerateMessage(
    String assistantMessageId,
    ProviderConfig config,
  ) async {
    final activeSessionId = state.activeSessionId;
    final session = state.sessions[activeSessionId];
    if (session == null) return;

    final messages = session.messages;
    final index = messages.indexWhere((m) => m.id == assistantMessageId);
    if (index <= 0) return;

    final userMessage = messages[index - 1];
    if (userMessage.role is! MessageRoleUser) return;

    _activeSubscription?.cancel();
    _activeSubscription = null;

    // Prune everything from the user message onwards (sendMessage recreates it)
    final newMessagesPruned = messages.sublist(0, index - 1);
    final removedIds = messages.sublist(index - 1).map((m) => m.id).toList();

    session.messages.clear();
    session.messages.addAll(newMessagesPruned);

    state = state.copyWith(
      messages: List.from(newMessagesPruned),
      isStreaming: false,
    );

    _localDb.deleteMessageIds(removedIds);

    // Resend
    await sendMessage(
      userMessage.content,
      config,
      sessionId: activeSessionId,
      attachments: userMessage.attachments,
    );
  }

  /// Prepares an edit by populating the input area and pruning the history
  /// from the selected user message onwards.
  Future<void> editMessage(
    String userMessageId,
    void Function(String, List<ChatAttachment>) onSetInput,
  ) async {
    final activeSessionId = state.activeSessionId;
    final session = state.sessions[activeSessionId];
    if (session == null) return;

    final messages = session.messages;
    final index = messages.indexWhere((m) => m.id == userMessageId);
    if (index < 0) return;

    final userMessage = messages[index];
    if (userMessage.role is! MessageRoleUser) return;

    _activeSubscription?.cancel();
    _activeSubscription = null;

    // Pass content to UI
    onSetInput(userMessage.content, userMessage.attachments);

    // Prune everything from this user message onwards
    final newMessages = messages.sublist(0, index);
    final removedIds = messages.sublist(index).map((m) => m.id).toList();

    session.messages.clear();
    session.messages.addAll(newMessages);

    state = state.copyWith(
      messages: List.from(newMessages),
      isStreaming: false,
    );

    _localDb.deleteMessageIds(removedIds);
  }

  /// Deletes a session and its messages from both memory and Isar.
  Future<void> deleteSession(String id) async {
    await _localDb.deleteSession(id);

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

  /// Sends a user [prompt], appends the user message to state, then streams
  /// the assistant response token-by-token.
  Future<void> sendMessage(
    String prompt,
    ProviderConfig config, {
    String? sessionId,
    List<ChatAttachment>? attachments,
    bool useCouncil = false,
  }) async {
    // 1. If this is a new chat, create a session first.
    String activeSessionId = sessionId ?? state.activeSessionId;
    Map<String, ChatSessionData> sessions = Map.from(state.sessions);

    if (activeSessionId == 'new') {
      activeSessionId = _uuid.v4();
      final title = prompt.length > 40
          ? '${prompt.substring(0, 40)}...'
          : prompt.isNotEmpty
          ? prompt
          : 'Attached files';
      final sessionData = ChatSessionData(
        id: activeSessionId,
        title: title,
        createdAt: DateTime.now(),
      );
      sessions[activeSessionId] = sessionData;

      // Persist the new session to Isar.
      await _localDb.saveSession(
        ChatSession(
          id: activeSessionId,
          title: title,
          providerId: '',
          createdAt: sessionData.createdAt,
        ),
      );

      // Auto-titling for extensive mode
      if (config.tokenUsageMode == TokenUsageMode.extensive &&
          prompt.isNotEmpty) {
        unawaited(_generateTitle(activeSessionId, prompt, config));
      }
    }

    // 2. Append user message.
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: const MessageRole.user(),
      content: prompt,
      timestamp: DateTime.now(),
      status: const MessageStatus.sent(),
      attachments: attachments ?? const [],
    );

    final updatedMessages = [...state.messages, userMessage];

    // Sync to session
    final activeSession = sessions[activeSessionId];
    if (activeSession != null) {
      activeSession.messages
        ..clear()
        ..addAll(updatedMessages);
    }

    state = state.copyWith(
      messages: updatedMessages,
      isStreaming: true,
      sessions: sessions,
      activeSessionId: activeSessionId,
    );

    // Persist user message to Isar.
    unawaited(_localDb.saveMessage(activeSessionId, userMessage));

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
      final stream = useCouncil
          ? _councilUsecase.executeCouncil(
              state.messages,
              prompt,
              _councilMembers,
            )
          : _repository.sendMessage(state.messages, prompt);

      _activeSubscription = stream.listen(
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

          // Persist final assistant message to Isar.
          _persistAssistantMessage(assistantId, buffer.toString());
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

          // Persist error message to Isar.
          _persistAssistantMessage(
            assistantId,
            buffer.isEmpty ? 'Error: $errorMsg' : buffer.toString(),
            errorMsg: errorMsg,
          );
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

  /// Persists the final assistant message to Isar.
  void _persistAssistantMessage(
    String messageId,
    String content, {
    String? errorMsg,
  }) {
    final sid = state.activeSessionId;
    if (sid == 'new') return;

    final msg = ChatMessage(
      id: messageId,
      role: const MessageRole.assistant(),
      content: content,
      timestamp: DateTime.now(),
      status: errorMsg != null
          ? MessageStatus.error(errorMsg)
          : const MessageStatus.sent(),
    );

    unawaited(_localDb.saveMessage(sid, msg));
  }

  /// Automatically generates a title using the LLM in the background and updates the active session.
  Future<void> _generateTitle(
    String sessionId,
    String firstMessage,
    ProviderConfig config,
  ) async {
    final titlePrompt =
        'Generate a short 3-5 word title for a chat starting with this message. Output ONLY the title, no markdown formatting, no quotes, or extra text: "$firstMessage"';

    final buffer = StringBuffer();
    try {
      final stream = _repository.sendMessage([], titlePrompt);
      await for (final token in stream) {
        buffer.write(token);
      }

      final title = buffer
          .toString()
          .trim()
          .replaceAll('"', '')
          .replaceAll('\n', ' ');
      if (title.isNotEmpty) {
        final session = state.sessions[sessionId];
        if (session != null) {
          session.title = title;
          // Trigger UI rebuild by copying the map
          state = state.copyWith(sessions: Map.from(state.sessions));

          await _localDb.saveSession(
            ChatSession(
              id: session.id,
              title: title,
              providerId: session.providerId,
              createdAt: session.createdAt,
            ),
          );
        }
      }
    } catch (e) {
      // Silently fail if auto-title background job errors out
    }
  }
}
