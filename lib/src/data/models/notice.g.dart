// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notice _$NoticeFromJson(Map<String, dynamic> json) => _Notice(
  id: json['id'] as String,
  seq: json['seq'] as String,
  no: (json['no'] as num).toInt(),
  title: json['title'] as String,
  department: json['department'] as String,
  regDate: (json['regDate'] as num).toInt(),
  hits: (json['hits'] as num).toInt(),
  corporation: json['corporation'] as String,
  files:
      (json['files'] as List<dynamic>)
          .map((e) => File.fromJson(e as Map<String, dynamic>))
          .toList(),
  contents:
      (json['contents'] as List<dynamic>).map((e) => e as String).toList(),
  link: json['link'] as String,
);

Map<String, dynamic> _$NoticeToJson(_Notice instance) => <String, dynamic>{
  'id': instance.id,
  'seq': instance.seq,
  'no': instance.no,
  'title': instance.title,
  'department': instance.department,
  'regDate': instance.regDate,
  'hits': instance.hits,
  'corporation': instance.corporation,
  'files': instance.files,
  'contents': instance.contents,
  'link': instance.link,
};
