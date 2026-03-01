import 'dart:convert';

import 'package:isar/isar.dart';

import 'package:ai_client_service/data/models/isar_chat_session.dart';
import 'package:ai_client_service/data/models/isar_chat_message.dart';
import 'package:ai_client_service/data/models/isar_provider_config.dart';
import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/data/models/chat_session.dart';
import 'package:ai_client_service/data/models/provider.dart';
import 'package:ai_client_service/data/models/chat_attachment.dart';

/// Provides CRUD operations on the local Isar database for chat sessions,
/// chat messages, and provider configurations.
class LocalDataSource {
  LocalDataSource(this._isar);

  final Isar _isar;

  // ---------------------------------------------------------------------------
  // Sessions
  // ---------------------------------------------------------------------------

  /// Returns all sessions ordered newest-first.
  Future<List<ChatSession>> getAllSessions() async {
    final entities = await _isar.isarChatSessions
        .where()
        .sortByCreatedAtMsDesc()
        .findAll();
    return entities.map(_sessionFromEntity).toList();
  }

  Future<ChatSession?> getSession(String sessionId) async {
    final entity = await _isar.isarChatSessions
        .where()
        .sessionIdEqualTo(sessionId)
        .findFirst();
    return entity == null ? null : _sessionFromEntity(entity);
  }

  Future<void> saveSession(ChatSession session, {String? modelName}) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.isarChatSessions
          .where()
          .sessionIdEqualTo(session.id)
          .findFirst();

      final entity = existing ?? IsarChatSession();
      entity
        ..sessionId = session.id
        ..title = session.title
        ..providerId = session.providerId
        ..modelName = modelName ?? ''
        ..createdAtMs = session.createdAt.millisecondsSinceEpoch;

      await _isar.isarChatSessions.put(entity);
    });
  }

  /// Deletes a session and all of its messages.
  Future<void> deleteSession(String sessionId) async {
    await _isar.writeTxn(() async {
      // Delete messages belonging to this session.
      await _isar.isarChatMessages
          .where()
          .sessionIdEqualTo(sessionId)
          .deleteAll();

      // Delete the session itself.
      await _isar.isarChatSessions
          .where()
          .sessionIdEqualTo(sessionId)
          .deleteAll();
    });
  }

  // ---------------------------------------------------------------------------
  // Messages
  // ---------------------------------------------------------------------------

  /// Returns messages for a given session, ordered by timestamp ascending.
  Future<List<ChatMessage>> getMessages(String sessionId) async {
    final entities = await _isar.isarChatMessages
        .where()
        .sessionIdEqualTo(sessionId)
        .sortByTimestampMs()
        .findAll();
    return entities.map(_messageFromEntity).toList();
  }

  Future<void> saveMessage(String sessionId, ChatMessage message) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.isarChatMessages
          .where()
          .messageIdEqualTo(message.id)
          .findFirst();

      final entity = existing ?? IsarChatMessage();
      entity
        ..messageId = message.id
        ..sessionId = sessionId
        ..role = _roleToString(message.role)
        ..content = message.content
        ..timestampMs = message.timestamp.millisecondsSinceEpoch
        ..status = _statusToString(message.status)
        ..errorMessage = message.status.maybeMap(
          error: (e) => e.errorMessage,
          orElse: () => null,
        )
        ..attachmentsJson = message.attachments
            .map((a) => jsonEncode(a.toJson()))
            .toList();

      await _isar.isarChatMessages.put(entity);
    });
  }

  Future<void> deleteMessagesForSession(String sessionId) async {
    await _isar.writeTxn(() async {
      await _isar.isarChatMessages
          .where()
          .sessionIdEqualTo(sessionId)
          .deleteAll();
    });
  }

  // ---------------------------------------------------------------------------
  // Provider Configs
  // ---------------------------------------------------------------------------

  Future<List<ProviderConfig>> getAllConfigs() async {
    final entities = await _isar.isarProviderConfigs.where().findAll();
    return entities.map(_configFromEntity).toList();
  }

  Future<void> saveConfig(ProviderConfig config) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.isarProviderConfigs
          .where()
          .configIdEqualTo(config.id)
          .findFirst();

      final entity = existing ?? IsarProviderConfig();
      _fillConfigEntity(entity, config);
      await _isar.isarProviderConfigs.put(entity);
    });
  }

  Future<void> deleteConfig(String configId) async {
    await _isar.writeTxn(() async {
      await _isar.isarProviderConfigs
          .where()
          .configIdEqualTo(configId)
          .deleteAll();
    });
  }

  // ---------------------------------------------------------------------------
  // Mapping helpers
  // ---------------------------------------------------------------------------

  ChatSession _sessionFromEntity(IsarChatSession e) => ChatSession(
    id: e.sessionId,
    title: e.title,
    providerId: e.providerId,
    createdAt: e.createdAt,
  );

  ChatMessage _messageFromEntity(IsarChatMessage e) => ChatMessage(
    id: e.messageId,
    role: _roleFromString(e.role),
    content: e.content,
    timestamp: e.timestamp,
    status: _statusFromString(e.status, e.errorMessage),
    attachments: e.attachmentsJson.map((jsonStr) {
      return ChatAttachment.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>,
      );
    }).toList(),
  );

  ProviderConfig _configFromEntity(IsarProviderConfig e) => ProviderConfig(
    id: e.configId,
    name: e.name,
    type: e.type == 'ollama' ? ProviderType.ollama : ProviderType.openai,
    baseUrl: e.baseUrl,
    modelName: e.modelName,
    description: e.description,
    organization: e.organization,
    temperature: e.temperature,
    maxTokens: e.maxTokens,
    topP: e.topP,
    frequencyPenalty: e.frequencyPenalty,
    presencePenalty: e.presencePenalty,
    timeout: e.timeout,
    maxRetries: e.maxRetries,
    isPinned: e.isPinned,
  );

  void _fillConfigEntity(IsarProviderConfig entity, ProviderConfig config) {
    entity
      ..configId = config.id
      ..name = config.name
      ..type = config.type == ProviderType.ollama ? 'ollama' : 'openai'
      ..baseUrl = config.baseUrl
      ..modelName = config.modelName
      ..description = config.description
      ..organization = config.organization
      ..temperature = config.temperature
      ..maxTokens = config.maxTokens
      ..topP = config.topP
      ..frequencyPenalty = config.frequencyPenalty
      ..presencePenalty = config.presencePenalty
      ..timeout = config.timeout
      ..maxRetries = config.maxRetries
      ..isPinned = config.isPinned;
  }

  static String _roleToString(MessageRole role) => role.map(
    user: (_) => 'user',
    assistant: (_) => 'assistant',
    system: (_) => 'system',
  );

  static MessageRole _roleFromString(String s) => switch (s) {
    'assistant' => const MessageRole.assistant(),
    'system' => const MessageRole.system(),
    _ => const MessageRole.user(),
  };

  static String _statusToString(MessageStatus status) => status.map(
    sending: (_) => 'sending',
    sent: (_) => 'sent',
    error: (_) => 'error',
  );

  static MessageStatus _statusFromString(String s, String? errorMsg) =>
      switch (s) {
        'sending' => const MessageStatus.sending(),
        'error' => MessageStatus.error(errorMsg),
        _ => const MessageStatus.sent(),
      };
}
