import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/dio_service.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/sources/remote/notice_source.dart';
import 'package:imdaesomun/src/data/sources/local/notice_local_source.dart';

abstract class NoticeRepository {
  Future<List<Notice>> getShNotices();
  Future<List<Notice>> getGhNotices();
  Future<Notice> getNoticeById(String id);
}

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeSource _noticeSource;
  final NoticeLocalSource _localSource;

  NoticeRepositoryImpl({
    required NoticeSource noticeSource,
    required NoticeLocalSource localSource,
  }) : _noticeSource = noticeSource,
       _localSource = localSource;

  @override
  Future<List<Notice>> getShNotices() async {
    final isLatest = await _noticeSource.isLatestShNotices();

    if (isLatest) {
      final local = await _localSource.getShNotices();
      if (local != null && local.isNotEmpty) return local;
    }

    final remote = await _noticeSource.getShNotices();
    await _localSource.saveShNotices(remote);
    return remote;
  }

  @override
  Future<List<Notice>> getGhNotices() async {
    final isLatest = await _noticeSource.isLatestGhNotices();

    if (isLatest) {
      final local = await _localSource.getGhNotices();
      if (local != null && local.isNotEmpty) return local;
    }

    final remote = await _noticeSource.getGhNotices();
    await _localSource.saveGhNotices(remote);
    return remote;
  }

  @override
  Future<Notice> getNoticeById(String id) async {
    final local = await _localSource.getNoticeById(id);
    if (local != null) return local;
    return await _noticeSource.getNoticeById(id);
  }
}

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NoticeRepositoryImpl(
    noticeSource: NoticeSource(dio),
    localSource: NoticeLocalSource(),
  );
});
