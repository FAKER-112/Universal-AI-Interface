// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatAttachmentImpl _$$ChatAttachmentImplFromJson(Map<String, dynamic> json) =>
    _$ChatAttachmentImpl(
      id: json['id'] as String,
      path: json['path'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
    );

Map<String, dynamic> _$$ChatAttachmentImplToJson(
        _$ChatAttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'name': instance.name,
      'mimeType': instance.mimeType,
    };
