import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

@freezed
abstract class Notice with _$Notice {
  const factory Notice({
    required String id,
    required String seq,
    required String title,
    required String regDate,
    required int hits,
    required String department,
    required String corporation,
    required String createAt,
    String? content,
    String? summary,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}
