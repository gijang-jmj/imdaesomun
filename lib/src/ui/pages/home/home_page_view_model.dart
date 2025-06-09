import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/core/providers/log_provider.dart';
import 'package:imdaesomun/src/core/services/notice_order_service.dart';
import 'package:imdaesomun/src/core/utils/timing_util.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';

class HomePageViewModel extends Notifier<void> {
  @override
  void build() {
    // void
  }

  void forceRefresh() {
    ref.read(shNoticesProvider.notifier).getNotices(throttle: false);
    ref.read(ghNoticesProvider.notifier).getNotices(throttle: false);
  }
}

final homePageViewModelProvider = NotifierProvider<HomePageViewModel, void>(
  HomePageViewModel.new,
);

class ShNotices extends AsyncNotifier<List<Notice>> {
  @override
  Future<List<Notice>> build() async {
    try {
      final notices = await ref.read(noticeRepositoryProvider).getShNotices();

      ref
          .read(logProvider.notifier)
          .log('[ShNotices.build]\n\nFetched ${notices.length} SH notices');

      return notices;
    } catch (e, st) {
      ref
          .read(logProvider.notifier)
          .log(
            '[ShNotices.build]\n\nFailed to fetch SH notices',
            error: e.toString(),
            stackTrace: st,
          );

      rethrow;
    }
  }

  Future<void> getNotices({bool throttle = true}) async {
    Throttle.call(
      'getNotices',
      throttle ? const Duration(seconds: 5) : Duration.zero,
      () async {
        try {
          state = const AsyncValue.loading();
          final notices =
              await ref.read(noticeRepositoryProvider).getShNotices();
          state = AsyncValue.data(notices);

          ref
              .read(logProvider.notifier)
              .log(
                '[ShNotices.getNotices]\n\nFetched ${notices.length} SH notices',
              );
        } catch (e, st) {
          state = AsyncValue.error(e, st);

          ref
              .read(logProvider.notifier)
              .log(
                '[ShNotices]\n\nFailed to fetch SH notices',
                error: e.toString(),
                stackTrace: st,
              );
        }
      },
    );
  }
}

final shNoticesProvider = AsyncNotifierProvider<ShNotices, List<Notice>>(
  ShNotices.new,
);

class GhNotices extends AsyncNotifier<List<Notice>> {
  @override
  Future<List<Notice>> build() async {
    try {
      final notices = await ref.read(noticeRepositoryProvider).getGhNotices();

      ref
          .read(logProvider.notifier)
          .log('[GhNotices.build]\n\nFetched ${notices.length} GH notices');

      return notices;
    } catch (e, st) {
      ref
          .read(logProvider.notifier)
          .log(
            '[GhNotices.build]\n\nFailed to fetch GH notices',
            error: e.toString(),
            stackTrace: st,
          );

      rethrow;
    }
  }

  Future<void> getNotices({bool throttle = true}) async {
    Throttle.call(
      'getGhNotices',
      throttle ? const Duration(seconds: 5) : Duration.zero,
      () async {
        try {
          state = const AsyncValue.loading();
          final notices =
              await ref.read(noticeRepositoryProvider).getGhNotices();
          state = AsyncValue.data(notices);

          ref
              .read(logProvider.notifier)
              .log(
                '[GhNotices.getNotices]\n\nFetched ${notices.length} GH notices',
              );
        } catch (e, st) {
          state = AsyncValue.error(e, st);

          ref
              .read(logProvider.notifier)
              .log(
                '[GhNotices]\n\nFailed to fetch GH notices',
                error: e.toString(),
                stackTrace: st,
              );
        }
      },
    );
  }
}

final ghNoticesProvider = AsyncNotifierProvider<GhNotices, List<Notice>>(
  GhNotices.new,
);

class NoticeOrderList extends AsyncNotifier<List<CorporationType>> {
  final List<CorporationType> _defaultOrder = NoticeOrderService.defaultOrder;

  @override
  Future<List<CorporationType>> build() async {
    return NoticeOrderService.getNoticeOrder();
  }

  updateOrder({required int oldIndex, required int newIndex}) async {
    if (oldIndex == newIndex) return;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final currentOrder = List<CorporationType>.from(
      state.value ?? _defaultOrder,
    );
    final item = currentOrder.removeAt(oldIndex);
    currentOrder.insert(newIndex, item);

    state = AsyncValue.data(currentOrder);
  }

  saveOrder() {
    NoticeOrderService.setNoticeOrder(state.value ?? _defaultOrder);
  }

  Future<void> cancelOrder() async {
    final previousOrder = await NoticeOrderService.getNoticeOrder();

    state = AsyncValue.data(previousOrder);
  }
}

final noticeOrderListProvider =
    AsyncNotifierProvider<NoticeOrderList, List<CorporationType>>(
      NoticeOrderList.new,
    );

final reorderModeProvider = StateProvider<bool>((ref) => false);
