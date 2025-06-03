// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_page_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoticePageState _$NoticePageStateFromJson(Map<String, dynamic> json) =>
    _NoticePageState(
      id: json['id'] as String,
      isSaved: json['isSaved'] as bool,
      notice:
          json['notice'] == null
              ? null
              : Notice.fromJson(json['notice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NoticePageStateToJson(_NoticePageState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isSaved': instance.isSaved,
      'notice': instance.notice,
    };
