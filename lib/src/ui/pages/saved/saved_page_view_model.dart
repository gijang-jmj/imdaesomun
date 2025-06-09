import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/providers/log_provider.dart';
import 'package:imdaesomun/src/core/providers/toast_provider.dart';
import 'package:imdaesomun/src/data/models/notice_pagination.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';

class SavedNotices extends AsyncNotifier<NoticePagination> {
  static final int _limit = 10;
  static final NoticePagination _initialPagination = NoticePagination(
    notices: [],
    nextOffset: 0,
    hasMore: true,
    totalFetched: 0,
    totalCount: 0,
    shCount: 0,
    ghCount: 0,
  );

  @override
  Future<NoticePagination> build() async {
    try {
      final user = ref.read(userProvider);

      if (user == null) {
        ref
            .read(logProvider.notifier)
            .log('SavedNotices.build\n\nUser is null', type: LogType.warning);
        return _initialPagination;
      }

      return await ref
          .read(noticeRepositoryProvider)
          .getSavedNotices(userId: user.uid, offset: 0, limit: _limit);
    } catch (e, st) {
      ref
          .read(logProvider.notifier)
          .log('SavedNotices.build', error: e.toString(), stackTrace: st);
      ref.read(globalToastProvider.notifier).showToast('저장된 공고 불러오기에 실패했어요');

      return _initialPagination;
    }
  }

  void resetSavedNotices() {
    state = AsyncValue.data(_initialPagination);
  }

  Future<void> refreshSavedNotices({String? userId, String? filter}) async {
    try {
      userId = userId ?? ref.read(userProvider)?.uid;

      if (userId == null) {
        ref
            .read(logProvider.notifier)
            .log(
              'SavedNotices.refreshSavedNotices\n\nUser is null',
              type: LogType.warning,
            );
        resetSavedNotices();
        return;
      }

      state = AsyncValue.loading();
      filter = filter ?? ref.read(savedFilterProvider);
      final pagination = await ref
          .read(noticeRepositoryProvider)
          .getSavedNotices(
            userId: userId,
            offset: 0,
            limit: _limit,
            corporation: filter == 'all' ? null : filter,
          );
      state = AsyncValue.data(pagination);
    } catch (e, st) {
      ref
          .read(logProvider.notifier)
          .log(
            'SavedNotices.refreshSavedNotices',
            error: e.toString(),
            stackTrace: st,
          );

      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getMoreSavedNotices({String? filter}) async {
    try {
      final user = ref.read(userProvider);

      if (user == null) {
        ref
            .read(logProvider.notifier)
            .log(
              'SavedNotices.getMoreSavedNotices\n\nUser is null',
              type: LogType.warning,
            );
        resetSavedNotices();
        return;
      }

      final currentState = state.value;
      final hasMore = currentState?.hasMore ?? true;

      if (!hasMore) {
        return;
      }

      filter = filter ?? ref.read(savedFilterProvider);
      final pagination = await ref
          .read(noticeRepositoryProvider)
          .getSavedNotices(
            userId: user.uid,
            offset: currentState?.nextOffset ?? 0,
            limit: _limit,
            corporation: filter == 'all' ? null : filter,
          );

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

final savedFilterProvider = StateProvider<String>((ref) {
  return 'all';
});
