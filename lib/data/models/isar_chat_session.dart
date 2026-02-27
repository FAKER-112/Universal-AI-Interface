import 'package:isar/isar.dart';

part 'isar_chat_session.g.dart';

/// Isar collection that persists chat sessions to local storage.
@collection
class IsarChatSession {
  Id id = Isar.autoIncrement;

  /// Application-level unique identifier for this session (UUID).
  @Index(unique: true)
  late String sessionId;

  /// Human-readable title derived from the first user message.
  late String title;

  /// The provider config ID associated with this session.
  late String providerId;

  /// The model name used during this session.
  late String modelName;

  /// Epoch-milliseconds timestamp of creation.
  late int createdAtMs;

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMs);

  set createdAt(DateTime dt) => createdAtMs = dt.millisecondsSinceEpoch;
}
