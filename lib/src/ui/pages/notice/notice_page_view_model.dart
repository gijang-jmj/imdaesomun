import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/providers/log_provider.dart';
import 'package:imdaesomun/src/core/utils/timing_util.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeDetail extends AutoDisposeFamilyAsyncNotifier<Notice, String> {
  @override
  Future<Notice> build(String id) async {
    return await ref.read(noticeRepositoryProvider).getNoticeById(id);
  }

  Future<void> openLink({required void Function(String error) onError}) async {
    final url = state.value?.link;

    if (url == null) {
      onError('공고 열기에 실패했어요\n잠시 후 다시 시도해주세요');
      return;
    }

    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      onError('공고 열기에 실패했어요\n잠시 후 다시 시도해주세요');
    }
  }
}

final noticeDetailProvider = AsyncNotifierProvider.autoDispose
    .family<NoticeDetail, Notice, String>(NoticeDetail.new);

class NoticeSaved extends AutoDisposeFamilyAsyncNotifier<bool, String> {
  @override
  Future<bool> build(String id) async {
    try {
      final user = ref.read(userProvider);

      if (user == null) {
        ref
            .read(logProvider.notifier)
            .log('[NoticeSaved]\n\nUser is null', type: LogType.warning);
        return false;
      }

      return await ref
          .read(noticeRepositoryProvider)
          .getNoticeSaved(noticeId: id, userId: user.uid);
    } catch (e) {
      ref
          .read(logProvider.notifier)
          .log(
            '[NoticeSaved]\n\ngetNoticeSaved failed\n\nid:\n$id\n\nError:\n$e',
          );

      rethrow;
    }
  }

  void setNoticeSaved({
    required bool isSaved,
    required String noticeId,
    required String userId,
  }) {
    Debounce.call(
      'setNoticeSaved',
      const Duration(milliseconds: 200),
      () async {
        if (isSaved) {
          await ref
              .read(noticeRepositoryProvider)
              .saveNotice(noticeId: noticeId, userId: userId);
        } else {
          await ref
              .read(noticeRepositoryProvider)
              .deleteNotice(noticeId: noticeId, userId: userId);
        }
        ref
            .read(savedNoticesProvider.notifier)
            .refreshSavedNotices(userId: userId);
      },
    );
  }

  Future<void> toggleSave({
    required bool isSaved,
    required String noticeId,
    required String userId,
  }) async {
    state = AsyncValue.data(isSaved);
    setNoticeSaved(isSaved: isSaved, noticeId: noticeId, userId: userId);
  }
}

final noticeSavedProvider = AsyncNotifierProvider.autoDispose
    .family<NoticeSaved, bool, String>(NoticeSaved.new);
