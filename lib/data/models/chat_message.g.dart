// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageRoleUserImpl _$$MessageRoleUserImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageRoleUserImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageRoleUserImplToJson(
        _$MessageRoleUserImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$MessageRoleAssistantImpl _$$MessageRoleAssistantImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageRoleAssistantImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageRoleAssistantImplToJson(
        _$MessageRoleAssistantImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$MessageRoleSystemImpl _$$MessageRoleSystemImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageRoleSystemImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageRoleSystemImplToJson(
        _$MessageRoleSystemImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$MessageStatusSendingImpl _$$MessageStatusSendingImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageStatusSendingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageStatusSendingImplToJson(
        _$MessageStatusSendingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$MessageStatusSentImpl _$$MessageStatusSentImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageStatusSentImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageStatusSentImplToJson(
        _$MessageStatusSentImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$MessageStatusErrorImpl _$$MessageStatusErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageStatusErrorImpl(
      json['errorMessage'] as String?,
      json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MessageStatusErrorImplToJson(
        _$MessageStatusErrorImpl instance) =>
    <String, dynamic>{
      'errorMessage': instance.errorMessage,
      'runtimeType': instance.$type,
    };

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      role: MessageRole.fromJson(json['role'] as Map<String, dynamic>),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': instance.status,
    };
