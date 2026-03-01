// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'council_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CouncilMember _$CouncilMemberFromJson(Map<String, dynamic> json) {
  return _CouncilMember.fromJson(json);
}

/// @nodoc
mixin _$CouncilMember {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get systemPrompt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CouncilMemberCopyWith<CouncilMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouncilMemberCopyWith<$Res> {
  factory $CouncilMemberCopyWith(
          CouncilMember value, $Res Function(CouncilMember) then) =
      _$CouncilMemberCopyWithImpl<$Res, CouncilMember>;
  @useResult
  $Res call({String id, String name, String systemPrompt});
}

/// @nodoc
class _$CouncilMemberCopyWithImpl<$Res, $Val extends CouncilMember>
    implements $CouncilMemberCopyWith<$Res> {
  _$CouncilMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? systemPrompt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      systemPrompt: null == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CouncilMemberImplCopyWith<$Res>
    implements $CouncilMemberCopyWith<$Res> {
  factory _$$CouncilMemberImplCopyWith(
          _$CouncilMemberImpl value, $Res Function(_$CouncilMemberImpl) then) =
      __$$CouncilMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String systemPrompt});
}

/// @nodoc
class __$$CouncilMemberImplCopyWithImpl<$Res>
    extends _$CouncilMemberCopyWithImpl<$Res, _$CouncilMemberImpl>
    implements _$$CouncilMemberImplCopyWith<$Res> {
  __$$CouncilMemberImplCopyWithImpl(
      _$CouncilMemberImpl _value, $Res Function(_$CouncilMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? systemPrompt = null,
  }) {
    return _then(_$CouncilMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      systemPrompt: null == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CouncilMemberImpl implements _CouncilMember {
  const _$CouncilMemberImpl(
      {required this.id, required this.name, required this.systemPrompt});

  factory _$CouncilMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouncilMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String systemPrompt;

  @override
  String toString() {
    return 'CouncilMember(id: $id, name: $name, systemPrompt: $systemPrompt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouncilMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, systemPrompt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CouncilMemberImplCopyWith<_$CouncilMemberImpl> get copyWith =>
      __$$CouncilMemberImplCopyWithImpl<_$CouncilMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouncilMemberImplToJson(
      this,
    );
  }
}

abstract class _CouncilMember implements CouncilMember {
  const factory _CouncilMember(
      {required final String id,
      required final String name,
      required final String systemPrompt}) = _$CouncilMemberImpl;

  factory _CouncilMember.fromJson(Map<String, dynamic> json) =
      _$CouncilMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get systemPrompt;
  @override
  @JsonKey(ignore: true)
  _$$CouncilMemberImplCopyWith<_$CouncilMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
