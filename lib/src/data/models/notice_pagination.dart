import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imdaesomun/src/data/models/notice.dart';

part 'notice_pagination.freezed.dart';
part 'notice_pagination.g.dart';

@freezed
abstract class NoticePagination with _$NoticePagination {
  const factory NoticePagination({
    required List<Notice> notices,
    required bool hasMore,
    required int nextOffset,
    required int totalFetched,
    required int totalCount,
    required int shCount,
    required int ghCount,
    required int ihCount,
    required int bmcCount,
  }) = _NoticePagination;

  factory NoticePagination.fromJson(Map<String, dynamic> json) =>
      _$NoticePaginationFromJson(json);
}
