import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imdaesomun/src/data/models/file.dart';

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
    required String corporation,
    required List<File> files,
    required List<String> contents,
    required String link,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}
