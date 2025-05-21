import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

@freezed
abstract class Notice with _$Notice {
  const factory Notice({
    required String id,
    required String seq,
    required int no,
    required String title,
    required String department,
    required int regDate,
    required int hits,
    required int createdAt,
    required List<Map<String, String>> files,
    required String html,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}
