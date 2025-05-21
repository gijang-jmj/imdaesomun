import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/sources/remote/notice_source.dart';

abstract class NoticeRepository {
  Future<List<Notice>> getShNotices();
  Future<List<Notice>> getGhNotices();
  Future<Notice> getNoticeById(String id);
}

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeSource _noticeSource;

  const NoticeRepositoryImpl({required NoticeSource noticeSource})
    : _noticeSource = noticeSource;

  @override
  Future<List<Notice>> getShNotices() async {
    return await _noticeSource.getShNotices();
  }

  @override
  Future<List<Notice>> getGhNotices() async {
    return await _noticeSource.getGhNotices();
  }

  @override
  Future<Notice> getNoticeById(String id) async {
    return await _noticeSource.getNoticeById(id);
  }
}
