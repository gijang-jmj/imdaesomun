import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/data/models/notice_pagination.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';

class SavedNotices extends AsyncNotifier<NoticePagination> {
  static final int _limit = 10;

  @override
  Future<NoticePagination> build() async {
    return await ref
        .read(noticeRepositoryProvider)
        .getSavedNotices(offset: 0, limit: _limit);
  }

  Future<void> refreshSavedNotices() async {
    try {
      state = AsyncValue.loading();
      final pagination = await ref
          .read(noticeRepositoryProvider)
          .getSavedNotices(offset: 0, limit: _limit);
      state = AsyncValue.data(pagination);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getMoreSavedNotices() async {
    try {
      final currentState = state.value;
      final hasMore = currentState?.hasMore ?? true;

      if (!hasMore) {
        return;
      }

      final offset = currentState?.nextOffset ?? 0;
      final pagination = await ref
          .read(noticeRepositoryProvider)
          .getSavedNotices(offset: offset, limit: _limit);

      // 기존 데이터와 새 데이터를 병합
      if (currentState != null) {
        final mergedNotices = [...currentState.notices, ...pagination.notices];
        state = AsyncValue.data(
          currentState.copyWith(
            notices: mergedNotices,
            nextOffset: pagination.nextOffset,
            hasMore: pagination.hasMore,
          ),
        );
      } else {
        state = AsyncValue.data(pagination);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final savedNoticesProvider =
    AsyncNotifierProvider<SavedNotices, NoticePagination>(SavedNotices.new);
