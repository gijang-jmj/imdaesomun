// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notice _$NoticeFromJson(Map<String, dynamic> json) => _Notice(
  id: json['id'] as String,
  seq: json['seq'] as String,
  title: json['title'] as String,
  regDate: json['regDate'] as String,
  hits: (json['hits'] as num).toInt(),
  department: json['department'] as String,
  corporation: json['corporation'] as String,
  createAt: json['createAt'] as String,
  content: json['content'] as String?,
  summary: json['summary'] as String?,
);

Map<String, dynamic> _$NoticeToJson(_Notice instance) => <String, dynamic>{
  'id': instance.id,
  'seq': instance.seq,
  'title': instance.title,
  'regDate': instance.regDate,
  'hits': instance.hits,
  'department': instance.department,
  'corporation': instance.corporation,
  'createAt': instance.createAt,
  'content': instance.content,
  'summary': instance.summary,
};
