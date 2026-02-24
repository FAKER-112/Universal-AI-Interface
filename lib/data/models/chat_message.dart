import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Represents the role of a message sender.
@freezed
sealed class MessageRole with _$MessageRole {
  const factory MessageRole.user() = MessageRoleUser;
  const factory MessageRole.assistant() = MessageRoleAssistant;
  const factory MessageRole.system() = MessageRoleSystem;

  factory MessageRole.fromJson(Map<String, dynamic> json) =>
      _$MessageRoleFromJson(json);
}

/// Represents the delivery status of a message.
@freezed
sealed class MessageStatus with _$MessageStatus {
  const factory MessageStatus.sending() = MessageStatusSending;
  const factory MessageStatus.sent() = MessageStatusSent;
  const factory MessageStatus.error([String? errorMessage]) =
      MessageStatusError;

  factory MessageStatus.fromJson(Map<String, dynamic> json) =>
      _$MessageStatusFromJson(json);
}

/// A single message in a chat conversation.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required MessageRole role,
    required String content,
    required DateTime timestamp,
    required MessageStatus status,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
