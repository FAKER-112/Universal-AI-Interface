import 'package:freezed_annotation/freezed_annotation.dart';

part 'council_member.freezed.dart';
part 'council_member.g.dart';

@freezed
class CouncilMember with _$CouncilMember {
  const factory CouncilMember({
    required String id,
    required String name,
    required String systemPrompt,
  }) = _CouncilMember;

  factory CouncilMember.fromJson(Map<String, dynamic> json) =>
      _$CouncilMemberFromJson(json);
}
