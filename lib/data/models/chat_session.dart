import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_session.freezed.dart';
part 'chat_session.g.dart';

/// A chat session grouping multiple messages under one conversation.
@freezed
abstract class ChatSession with _$ChatSession {
  const factory ChatSession({
    required String id,
    required String title,
    required String providerId,
    required DateTime createdAt,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
}
