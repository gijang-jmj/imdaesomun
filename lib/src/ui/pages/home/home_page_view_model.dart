import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';

class ShNotices extends AsyncNotifier<List<Notice>> {
  @override
  Future<List<Notice>> build() async {
    return await ref.read(noticeRepositoryProvider).getShNotices();
  }

  Future<void> getNotices() async {
    try {
      state = const AsyncValue.loading();
      final notices = await ref.read(noticeRepositoryProvider).getShNotices();
      state = AsyncValue.data(notices);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final shNoticesProvider = AsyncNotifierProvider<ShNotices, List<Notice>>(
  ShNotices.new,
);

class GhNotices extends AsyncNotifier<List<Notice>> {
  @override
  Future<List<Notice>> build() async {
    return await ref.read(noticeRepositoryProvider).getGhNotices();
  }

  Future<void> getNotices() async {
    try {
      state = const AsyncValue.loading();
      final notices = await ref.read(noticeRepositoryProvider).getGhNotices();
      state = AsyncValue.data(notices);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final ghNoticesProvider = AsyncNotifierProvider<GhNotices, List<Notice>>(
  GhNotices.new,
);
