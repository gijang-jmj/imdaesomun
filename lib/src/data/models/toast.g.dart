// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Toast _$ToastFromJson(Map<String, dynamic> json) => _Toast(
  message: json['message'] as String,
  isVisible: json['isVisible'] as bool? ?? false,
  durationInSeconds: (json['durationInSeconds'] as num?)?.toInt() ?? 3,
);

Map<String, dynamic> _$ToastToJson(_Toast instance) => <String, dynamic>{
  'message': instance.message,
  'isVisible': instance.isVisible,
  'durationInSeconds': instance.durationInSeconds,
};
