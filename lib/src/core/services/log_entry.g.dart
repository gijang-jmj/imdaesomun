// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LogEntry _$LogEntryFromJson(Map<String, dynamic> json) => _LogEntry(
  message: json['message'] as String,
  type: $enumDecode(_$LogTypeEnumMap, json['type']),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$LogEntryToJson(_LogEntry instance) => <String, dynamic>{
  'message': instance.message,
  'type': _$LogTypeEnumMap[instance.type]!,
  'timestamp': instance.timestamp.toIso8601String(),
};

const _$LogTypeEnumMap = {
  LogType.error: 'error',
  LogType.warning: 'warning',
  LogType.info: 'info',
};
