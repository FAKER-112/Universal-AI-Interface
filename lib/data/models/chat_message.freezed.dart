// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageRole _$MessageRoleFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'user':
      return MessageRoleUser.fromJson(json);
    case 'assistant':
      return MessageRoleAssistant.fromJson(json);
    case 'system':
      return MessageRoleSystem.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'MessageRole',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$MessageRole {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() user,
    required TResult Function() assistant,
    required TResult Function() system,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? user,
    TResult? Function()? assistant,
    TResult? Function()? system,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? user,
    TResult Function()? assistant,
    TResult Function()? system,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageRoleUser value) user,
    required TResult Function(MessageRoleAssistant value) assistant,
    required TResult Function(MessageRoleSystem value) system,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageRoleUser value)? user,
    TResult? Function(MessageRoleAssistant value)? assistant,
    TResult? Function(MessageRoleSystem value)? system,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageRoleUser value)? user,
    TResult Function(MessageRoleAssistant value)? assistant,
    TResult Function(MessageRoleSystem value)? system,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageRoleCopyWith<$Res> {
  factory $MessageRoleCopyWith(
          MessageRole value, $Res Function(MessageRole) then) =
      _$MessageRoleCopyWithImpl<$Res, MessageRole>;
}

/// @nodoc
class _$MessageRoleCopyWithImpl<$Res, $Val extends MessageRole>
    implements $MessageRoleCopyWith<$Res> {
  _$MessageRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$MessageRoleUserImplCopyWith<$Res> {
  factory _$$MessageRoleUserImplCopyWith(_$MessageRoleUserImpl value,
          $Res Function(_$MessageRoleUserImpl) then) =
      __$$MessageRoleUserImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MessageRoleUserImplCopyWithImpl<$Res>
    extends _$MessageRoleCopyWithImpl<$Res, _$MessageRoleUserImpl>
    implements _$$MessageRoleUserImplCopyWith<$Res> {
  __$$MessageRoleUserImplCopyWithImpl(
      _$MessageRoleUserImpl _value, $Res Function(_$MessageRoleUserImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$MessageRoleUserImpl implements MessageRoleUser {
  const _$MessageRoleUserImpl({final String? $type}) : $type = $type ?? 'user';

  factory _$MessageRoleUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageRoleUserImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageRole.user()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MessageRoleUserImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() user,
    required TResult Function() assistant,
    required TResult Function() system,
  }) {
    return user();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? user,
    TResult? Function()? assistant,
    TResult? Function()? system,
  }) {
    return user?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? user,
    TResult Function()? assistant,
    TResult Function()? system,
    required TResult orElse(),
  }) {
    if (user != null) {
      return user();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageRoleUser value) user,
    required TResult Function(MessageRoleAssistant value) assistant,
    required TResult Function(MessageRoleSystem value) system,
  }) {
    return user(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageRoleUser value)? user,
    TResult? Function(MessageRoleAssistant value)? assistant,
    TResult? Function(MessageRoleSystem value)? system,
  }) {
    return user?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageRoleUser value)? user,
    TResult Function(MessageRoleAssistant value)? assistant,
    TResult Function(MessageRoleSystem value)? system,
    required TResult orElse(),
  }) {
    if (user != null) {
      return user(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageRoleUserImplToJson(
      this,
    );
  }
}

abstract class MessageRoleUser implements MessageRole {
  const factory MessageRoleUser() = _$MessageRoleUserImpl;

  factory MessageRoleUser.fromJson(Map<String, dynamic> json) =
      _$MessageRoleUserImpl.fromJson;
}

/// @nodoc
abstract class _$$MessageRoleAssistantImplCopyWith<$Res> {
  factory _$$MessageRoleAssistantImplCopyWith(_$MessageRoleAssistantImpl value,
          $Res Function(_$MessageRoleAssistantImpl) then) =
      __$$MessageRoleAssistantImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MessageRoleAssistantImplCopyWithImpl<$Res>
    extends _$MessageRoleCopyWithImpl<$Res, _$MessageRoleAssistantImpl>
    implements _$$MessageRoleAssistantImplCopyWith<$Res> {
  __$$MessageRoleAssistantImplCopyWithImpl(_$MessageRoleAssistantImpl _value,
      $Res Function(_$MessageRoleAssistantImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$MessageRoleAssistantImpl implements MessageRoleAssistant {
  const _$MessageRoleAssistantImpl({final String? $type})
      : $type = $type ?? 'assistant';

  factory _$MessageRoleAssistantImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageRoleAssistantImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageRole.assistant()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageRoleAssistantImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() user,
    required TResult Function() assistant,
    required TResult Function() system,
  }) {
    return assistant();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? user,
    TResult? Function()? assistant,
    TResult? Function()? system,
  }) {
    return assistant?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? user,
    TResult Function()? assistant,
    TResult Function()? system,
    required TResult orElse(),
  }) {
    if (assistant != null) {
      return assistant();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageRoleUser value) user,
    required TResult Function(MessageRoleAssistant value) assistant,
    required TResult Function(MessageRoleSystem value) system,
  }) {
    return assistant(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageRoleUser value)? user,
    TResult? Function(MessageRoleAssistant value)? assistant,
    TResult? Function(MessageRoleSystem value)? system,
  }) {
    return assistant?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageRoleUser value)? user,
    TResult Function(MessageRoleAssistant value)? assistant,
    TResult Function(MessageRoleSystem value)? system,
    required TResult orElse(),
  }) {
    if (assistant != null) {
      return assistant(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageRoleAssistantImplToJson(
      this,
    );
  }
}

abstract class MessageRoleAssistant implements MessageRole {
  const factory MessageRoleAssistant() = _$MessageRoleAssistantImpl;

  factory MessageRoleAssistant.fromJson(Map<String, dynamic> json) =
      _$MessageRoleAssistantImpl.fromJson;
}

/// @nodoc
abstract class _$$MessageRoleSystemImplCopyWith<$Res> {
  factory _$$MessageRoleSystemImplCopyWith(_$MessageRoleSystemImpl value,
          $Res Function(_$MessageRoleSystemImpl) then) =
      __$$MessageRoleSystemImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MessageRoleSystemImplCopyWithImpl<$Res>
    extends _$MessageRoleCopyWithImpl<$Res, _$MessageRoleSystemImpl>
    implements _$$MessageRoleSystemImplCopyWith<$Res> {
  __$$MessageRoleSystemImplCopyWithImpl(_$MessageRoleSystemImpl _value,
      $Res Function(_$MessageRoleSystemImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$MessageRoleSystemImpl implements MessageRoleSystem {
  const _$MessageRoleSystemImpl({final String? $type})
      : $type = $type ?? 'system';

  factory _$MessageRoleSystemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageRoleSystemImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageRole.system()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MessageRoleSystemImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() user,
    required TResult Function() assistant,
    required TResult Function() system,
  }) {
    return system();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? user,
    TResult? Function()? assistant,
    TResult? Function()? system,
  }) {
    return system?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? user,
    TResult Function()? assistant,
    TResult Function()? system,
    required TResult orElse(),
  }) {
    if (system != null) {
      return system();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageRoleUser value) user,
    required TResult Function(MessageRoleAssistant value) assistant,
    required TResult Function(MessageRoleSystem value) system,
  }) {
    return system(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageRoleUser value)? user,
    TResult? Function(MessageRoleAssistant value)? assistant,
    TResult? Function(MessageRoleSystem value)? system,
  }) {
    return system?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageRoleUser value)? user,
    TResult Function(MessageRoleAssistant value)? assistant,
    TResult Function(MessageRoleSystem value)? system,
    required TResult orElse(),
  }) {
    if (system != null) {
      return system(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageRoleSystemImplToJson(
      this,
    );
  }
}

abstract class MessageRoleSystem implements MessageRole {
  const factory MessageRoleSystem() = _$MessageRoleSystemImpl;

  factory MessageRoleSystem.fromJson(Map<String, dynamic> json) =
      _$MessageRoleSystemImpl.fromJson;
}

MessageStatus _$MessageStatusFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'sending':
      return MessageStatusSending.fromJson(json);
    case 'sent':
      return MessageStatusSent.fromJson(json);
    case 'error':
      return MessageStatusError.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'MessageStatus',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$MessageStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() sent,
    required TResult Function(String? errorMessage) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? sent,
    TResult? Function(String? errorMessage)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? sent,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageStatusSending value) sending,
    required TResult Function(MessageStatusSent value) sent,
    required TResult Function(MessageStatusError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageStatusSending value)? sending,
    TResult? Function(MessageStatusSent value)? sent,
    TResult? Function(MessageStatusError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageStatusSending value)? sending,
    TResult Function(MessageStatusSent value)? sent,
    TResult Function(MessageStatusError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageStatusCopyWith<$Res> {
  factory $MessageStatusCopyWith(
          MessageStatus value, $Res Function(MessageStatus) then) =
      _$MessageStatusCopyWithImpl<$Res, MessageStatus>;
}

/// @nodoc
class _$MessageStatusCopyWithImpl<$Res, $Val extends MessageStatus>
    implements $MessageStatusCopyWith<$Res> {
  _$MessageStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$MessageStatusSendingImplCopyWith<$Res> {
  factory _$$MessageStatusSendingImplCopyWith(_$MessageStatusSendingImpl value,
          $Res Function(_$MessageStatusSendingImpl) then) =
      __$$MessageStatusSendingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MessageStatusSendingImplCopyWithImpl<$Res>
    extends _$MessageStatusCopyWithImpl<$Res, _$MessageStatusSendingImpl>
    implements _$$MessageStatusSendingImplCopyWith<$Res> {
  __$$MessageStatusSendingImplCopyWithImpl(_$MessageStatusSendingImpl _value,
      $Res Function(_$MessageStatusSendingImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$MessageStatusSendingImpl implements MessageStatusSending {
  const _$MessageStatusSendingImpl({final String? $type})
      : $type = $type ?? 'sending';

  factory _$MessageStatusSendingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageStatusSendingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageStatus.sending()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageStatusSendingImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() sent,
    required TResult Function(String? errorMessage) error,
  }) {
    return sending();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? sent,
    TResult? Function(String? errorMessage)? error,
  }) {
    return sending?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? sent,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (sending != null) {
      return sending();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageStatusSending value) sending,
    required TResult Function(MessageStatusSent value) sent,
    required TResult Function(MessageStatusError value) error,
  }) {
    return sending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageStatusSending value)? sending,
    TResult? Function(MessageStatusSent value)? sent,
    TResult? Function(MessageStatusError value)? error,
  }) {
    return sending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageStatusSending value)? sending,
    TResult Function(MessageStatusSent value)? sent,
    TResult Function(MessageStatusError value)? error,
    required TResult orElse(),
  }) {
    if (sending != null) {
      return sending(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageStatusSendingImplToJson(
      this,
    );
  }
}

abstract class MessageStatusSending implements MessageStatus {
  const factory MessageStatusSending() = _$MessageStatusSendingImpl;

  factory MessageStatusSending.fromJson(Map<String, dynamic> json) =
      _$MessageStatusSendingImpl.fromJson;
}

/// @nodoc
abstract class _$$MessageStatusSentImplCopyWith<$Res> {
  factory _$$MessageStatusSentImplCopyWith(_$MessageStatusSentImpl value,
          $Res Function(_$MessageStatusSentImpl) then) =
      __$$MessageStatusSentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MessageStatusSentImplCopyWithImpl<$Res>
    extends _$MessageStatusCopyWithImpl<$Res, _$MessageStatusSentImpl>
    implements _$$MessageStatusSentImplCopyWith<$Res> {
  __$$MessageStatusSentImplCopyWithImpl(_$MessageStatusSentImpl _value,
      $Res Function(_$MessageStatusSentImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$MessageStatusSentImpl implements MessageStatusSent {
  const _$MessageStatusSentImpl({final String? $type})
      : $type = $type ?? 'sent';

  factory _$MessageStatusSentImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageStatusSentImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageStatus.sent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MessageStatusSentImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() sent,
    required TResult Function(String? errorMessage) error,
  }) {
    return sent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? sent,
    TResult? Function(String? errorMessage)? error,
  }) {
    return sent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? sent,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (sent != null) {
      return sent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageStatusSending value) sending,
    required TResult Function(MessageStatusSent value) sent,
    required TResult Function(MessageStatusError value) error,
  }) {
    return sent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageStatusSending value)? sending,
    TResult? Function(MessageStatusSent value)? sent,
    TResult? Function(MessageStatusError value)? error,
  }) {
    return sent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageStatusSending value)? sending,
    TResult Function(MessageStatusSent value)? sent,
    TResult Function(MessageStatusError value)? error,
    required TResult orElse(),
  }) {
    if (sent != null) {
      return sent(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageStatusSentImplToJson(
      this,
    );
  }
}

abstract class MessageStatusSent implements MessageStatus {
  const factory MessageStatusSent() = _$MessageStatusSentImpl;

  factory MessageStatusSent.fromJson(Map<String, dynamic> json) =
      _$MessageStatusSentImpl.fromJson;
}

/// @nodoc
abstract class _$$MessageStatusErrorImplCopyWith<$Res> {
  factory _$$MessageStatusErrorImplCopyWith(_$MessageStatusErrorImpl value,
          $Res Function(_$MessageStatusErrorImpl) then) =
      __$$MessageStatusErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? errorMessage});
}

/// @nodoc
class __$$MessageStatusErrorImplCopyWithImpl<$Res>
    extends _$MessageStatusCopyWithImpl<$Res, _$MessageStatusErrorImpl>
    implements _$$MessageStatusErrorImplCopyWith<$Res> {
  __$$MessageStatusErrorImplCopyWithImpl(_$MessageStatusErrorImpl _value,
      $Res Function(_$MessageStatusErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = freezed,
  }) {
    return _then(_$MessageStatusErrorImpl(
      freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageStatusErrorImpl implements MessageStatusError {
  const _$MessageStatusErrorImpl([this.errorMessage, final String? $type])
      : $type = $type ?? 'error';

  factory _$MessageStatusErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageStatusErrorImplFromJson(json);

  @override
  final String? errorMessage;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageStatus.error(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageStatusErrorImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageStatusErrorImplCopyWith<_$MessageStatusErrorImpl> get copyWith =>
      __$$MessageStatusErrorImplCopyWithImpl<_$MessageStatusErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() sent,
    required TResult Function(String? errorMessage) error,
  }) {
    return error(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? sent,
    TResult? Function(String? errorMessage)? error,
  }) {
    return error?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? sent,
    TResult Function(String? errorMessage)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageStatusSending value) sending,
    required TResult Function(MessageStatusSent value) sent,
    required TResult Function(MessageStatusError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageStatusSending value)? sending,
    TResult? Function(MessageStatusSent value)? sent,
    TResult? Function(MessageStatusError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageStatusSending value)? sending,
    TResult Function(MessageStatusSent value)? sent,
    TResult Function(MessageStatusError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageStatusErrorImplToJson(
      this,
    );
  }
}

abstract class MessageStatusError implements MessageStatus {
  const factory MessageStatusError([final String? errorMessage]) =
      _$MessageStatusErrorImpl;

  factory MessageStatusError.fromJson(Map<String, dynamic> json) =
      _$MessageStatusErrorImpl.fromJson;

  String? get errorMessage;
  @JsonKey(ignore: true)
  _$$MessageStatusErrorImplCopyWith<_$MessageStatusErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  MessageRole get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  MessageStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      MessageRole role,
      String content,
      DateTime timestamp,
      MessageStatus status});

  $MessageRoleCopyWith<$Res> get role;
  $MessageStatusCopyWith<$Res> get status;
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRole,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageRoleCopyWith<$Res> get role {
    return $MessageRoleCopyWith<$Res>(_value.role, (value) {
      return _then(_value.copyWith(role: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageStatusCopyWith<$Res> get status {
    return $MessageStatusCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MessageRole role,
      String content,
      DateTime timestamp,
      MessageStatus status});

  @override
  $MessageRoleCopyWith<$Res> get role;
  @override
  $MessageStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? status = null,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRole,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.role,
      required this.content,
      required this.timestamp,
      required this.status});

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final MessageRole role;
  @override
  final String content;
  @override
  final DateTime timestamp;
  @override
  final MessageStatus status;

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, timestamp: $timestamp, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, role, content, timestamp, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final MessageRole role,
      required final String content,
      required final DateTime timestamp,
      required final MessageStatus status}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  MessageRole get role;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  MessageStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
