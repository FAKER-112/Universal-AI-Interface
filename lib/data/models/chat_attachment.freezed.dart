// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatAttachment _$ChatAttachmentFromJson(Map<String, dynamic> json) {
  return _ChatAttachment.fromJson(json);
}

/// @nodoc
mixin _$ChatAttachment {
  String get id => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatAttachmentCopyWith<ChatAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatAttachmentCopyWith<$Res> {
  factory $ChatAttachmentCopyWith(
          ChatAttachment value, $Res Function(ChatAttachment) then) =
      _$ChatAttachmentCopyWithImpl<$Res, ChatAttachment>;
  @useResult
  $Res call({String id, String path, String name, String mimeType});
}

/// @nodoc
class _$ChatAttachmentCopyWithImpl<$Res, $Val extends ChatAttachment>
    implements $ChatAttachmentCopyWith<$Res> {
  _$ChatAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
    Object? mimeType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatAttachmentImplCopyWith<$Res>
    implements $ChatAttachmentCopyWith<$Res> {
  factory _$$ChatAttachmentImplCopyWith(_$ChatAttachmentImpl value,
          $Res Function(_$ChatAttachmentImpl) then) =
      __$$ChatAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String path, String name, String mimeType});
}

/// @nodoc
class __$$ChatAttachmentImplCopyWithImpl<$Res>
    extends _$ChatAttachmentCopyWithImpl<$Res, _$ChatAttachmentImpl>
    implements _$$ChatAttachmentImplCopyWith<$Res> {
  __$$ChatAttachmentImplCopyWithImpl(
      _$ChatAttachmentImpl _value, $Res Function(_$ChatAttachmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
    Object? mimeType = null,
  }) {
    return _then(_$ChatAttachmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatAttachmentImpl implements _ChatAttachment {
  const _$ChatAttachmentImpl(
      {required this.id,
      required this.path,
      required this.name,
      required this.mimeType});

  factory _$ChatAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatAttachmentImplFromJson(json);

  @override
  final String id;
  @override
  final String path;
  @override
  final String name;
  @override
  final String mimeType;

  @override
  String toString() {
    return 'ChatAttachment(id: $id, path: $path, name: $name, mimeType: $mimeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatAttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, path, name, mimeType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatAttachmentImplCopyWith<_$ChatAttachmentImpl> get copyWith =>
      __$$ChatAttachmentImplCopyWithImpl<_$ChatAttachmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatAttachmentImplToJson(
      this,
    );
  }
}

abstract class _ChatAttachment implements ChatAttachment {
  const factory _ChatAttachment(
      {required final String id,
      required final String path,
      required final String name,
      required final String mimeType}) = _$ChatAttachmentImpl;

  factory _ChatAttachment.fromJson(Map<String, dynamic> json) =
      _$ChatAttachmentImpl.fromJson;

  @override
  String get id;
  @override
  String get path;
  @override
  String get name;
  @override
  String get mimeType;
  @override
  @JsonKey(ignore: true)
  _$$ChatAttachmentImplCopyWith<_$ChatAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
