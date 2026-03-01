// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'council_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouncilMemberImpl _$$CouncilMemberImplFromJson(Map<String, dynamic> json) =>
    _$CouncilMemberImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      systemPrompt: json['systemPrompt'] as String,
    );

Map<String, dynamic> _$$CouncilMemberImplToJson(_$CouncilMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'systemPrompt': instance.systemPrompt,
    };
