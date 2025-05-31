// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginState _$LoginStateFromJson(Map<String, dynamic> json) => _LoginState(
  obscure: json['obscure'] as bool,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginStateToJson(_LoginState instance) =>
    <String, dynamic>{
      'obscure': instance.obscure,
      'email': instance.email,
      'password': instance.password,
    };
