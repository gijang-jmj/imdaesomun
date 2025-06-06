// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoticePagination _$NoticePaginationFromJson(Map<String, dynamic> json) =>
    _NoticePagination(
      notices:
          (json['notices'] as List<dynamic>)
              .map((e) => Notice.fromJson(e as Map<String, dynamic>))
              .toList(),
      hasMore: json['hasMore'] as bool,
      nextOffset: (json['nextOffset'] as num).toInt(),
      totalFetched: (json['totalFetched'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      shCount: (json['shCount'] as num).toInt(),
      ghCount: (json['ghCount'] as num).toInt(),
    );

Map<String, dynamic> _$NoticePaginationToJson(_NoticePagination instance) =>
    <String, dynamic>{
      'notices': instance.notices,
      'hasMore': instance.hasMore,
      'nextOffset': instance.nextOffset,
      'totalFetched': instance.totalFetched,
      'totalCount': instance.totalCount,
      'shCount': instance.shCount,
      'ghCount': instance.ghCount,
    };
