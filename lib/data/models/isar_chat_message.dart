import 'package:isar/isar.dart';

part 'isar_chat_message.g.dart';

/// Isar collection that persists individual chat messages.
@collection
class IsarChatMessage {
  Id id = Isar.autoIncrement;

  /// Application-level unique identifier for this message (UUID).
  @Index()
  late String messageId;

  /// The session this message belongs to.
  @Index()
  late String sessionId;

  /// "user", "assistant", or "system".
  late String role;

  /// The full text content of this message.
  late String content;

  /// Epoch-milliseconds timestamp.
  late int timestampMs;

  /// "sending", "sent", or "error".
  late String status;

  /// Optional error description (only populated when status == "error").
  String? errorMessage;

  DateTime get timestamp => DateTime.fromMillisecondsSinceEpoch(timestampMs);

  set timestamp(DateTime dt) => timestampMs = dt.millisecondsSinceEpoch;
}
