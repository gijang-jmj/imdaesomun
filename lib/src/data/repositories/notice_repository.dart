import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/models/notice_pagination.dart';

abstract class NoticeRepository {
  Future<List<Notice>> getShNotices();
  Future<List<Notice>> getGhNotices();
  Future<Notice> getNoticeById(String id);
  Future<void> saveNotice({required String noticeId, required String userId});
  Future<void> deleteNotice({required String noticeId, required String userId});
  Future<bool> getNoticeSaved({
    required String noticeId,
    required String userId,
  });
  Future<NoticePagination> getSavedNotices({
    required String userId,
    required int offset,
    int? limit,
    String? corporation,
  });
}
