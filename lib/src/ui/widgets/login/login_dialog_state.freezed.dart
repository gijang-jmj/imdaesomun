// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_dialog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginDialogState {

 bool get obscure; String get email; String get password;
/// Create a copy of LoginDialogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginDialogStateCopyWith<LoginDialogState> get copyWith => _$LoginDialogStateCopyWithImpl<LoginDialogState>(this as LoginDialogState, _$identity);

  /// Serializes this LoginDialogState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginDialogState&&(identical(other.obscure, obscure) || other.obscure == obscure)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,obscure,email,password);

@override
String toString() {
  return 'LoginDialogState(obscure: $obscure, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $LoginDialogStateCopyWith<$Res>  {
  factory $LoginDialogStateCopyWith(LoginDialogState value, $Res Function(LoginDialogState) _then) = _$LoginDialogStateCopyWithImpl;
@useResult
$Res call({
 bool obscure, String email, String password
});




}
/// @nodoc
class _$LoginDialogStateCopyWithImpl<$Res>
    implements $LoginDialogStateCopyWith<$Res> {
  _$LoginDialogStateCopyWithImpl(this._self, this._then);

  final LoginDialogState _self;
  final $Res Function(LoginDialogState) _then;

/// Create a copy of LoginDialogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? obscure = null,Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
obscure: null == obscure ? _self.obscure : obscure // ignore: cast_nullable_to_non_nullable
as bool,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LoginDialogState implements LoginDialogState {
  const _LoginDialogState({required this.obscure, required this.email, required this.password});
  factory _LoginDialogState.fromJson(Map<String, dynamic> json) => _$LoginDialogStateFromJson(json);

@override final  bool obscure;
@override final  String email;
@override final  String password;

/// Create a copy of LoginDialogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginDialogStateCopyWith<_LoginDialogState> get copyWith => __$LoginDialogStateCopyWithImpl<_LoginDialogState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginDialogStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginDialogState&&(identical(other.obscure, obscure) || other.obscure == obscure)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,obscure,email,password);

@override
String toString() {
  return 'LoginDialogState(obscure: $obscure, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$LoginDialogStateCopyWith<$Res> implements $LoginDialogStateCopyWith<$Res> {
  factory _$LoginDialogStateCopyWith(_LoginDialogState value, $Res Function(_LoginDialogState) _then) = __$LoginDialogStateCopyWithImpl;
@override @useResult
$Res call({
 bool obscure, String email, String password
});




}
/// @nodoc
class __$LoginDialogStateCopyWithImpl<$Res>
    implements _$LoginDialogStateCopyWith<$Res> {
  __$LoginDialogStateCopyWithImpl(this._self, this._then);

  final _LoginDialogState _self;
  final $Res Function(_LoginDialogState) _then;

/// Create a copy of LoginDialogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? obscure = null,Object? email = null,Object? password = null,}) {
  return _then(_LoginDialogState(
obscure: null == obscure ? _self.obscure : obscure // ignore: cast_nullable_to_non_nullable
as bool,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
