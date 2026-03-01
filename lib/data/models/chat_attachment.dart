import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_attachment.freezed.dart';
part 'chat_attachment.g.dart';

/// Represents a file attached to a chat message.
@freezed
abstract class ChatAttachment with _$ChatAttachment {
  const factory ChatAttachment({
    required String id,
    required String path,
    required String name,
    required String mimeType,
  }) = _ChatAttachment;

  factory ChatAttachment.fromJson(Map<String, dynamic> json) =>
      _$ChatAttachmentFromJson(json);
}
