import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/providers/dio_provider.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/models/notice_pagination.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';
import 'package:imdaesomun/src/data/sources/remote/notice_source.dart';
import 'package:imdaesomun/src/data/sources/local/notice_local_source.dart';

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NoticeRepositoryImpl(
    noticeSource: NoticeSource(dio),
    localSource: NoticeLocalSource(),
  );
});

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

  @override
  Future<void> saveNotice({
    required String noticeId,
    required String userId,
  }) async {
    await _noticeSource.saveNotice(noticeId: noticeId, userId: userId);
  }

  @override
  Future<void> deleteNotice({
    required String noticeId,
    required String userId,
  }) async {
    await _noticeSource.deleteNotice(noticeId: noticeId, userId: userId);
  }

  @override
  Future<bool> getNoticeSaved({
    required String noticeId,
    required String userId,
  }) async {
    return await _noticeSource.getNoticeSaved(
      noticeId: noticeId,
      userId: userId,
    );
  }

  @override
  Future<NoticePagination> getSavedNotices({
    required String userId,
    required int offset,
    int? limit,
    String? corporation,
  }) async {
    return await _noticeSource.getSavedNotices(
      userId: userId,
      offset: offset,
      limit: limit,
      corporation: corporation,
    );
  }
}
