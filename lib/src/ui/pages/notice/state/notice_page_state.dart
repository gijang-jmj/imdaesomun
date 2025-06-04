import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imdaesomun/src/data/models/notice.dart';

part 'notice_page_state.freezed.dart';
part 'notice_page_state.g.dart';

@freezed
abstract class NoticePageState with _$NoticePageState {
  const factory NoticePageState({required String id, required bool isSaved}) =
      _NoticePageState;

  factory NoticePageState.fromJson(Map<String, dynamic> json) =>
      _$NoticePageStateFromJson(json);
}
