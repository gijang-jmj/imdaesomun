import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/core/utils/timing_util.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';
import 'package:imdaesomun/src/data/sources/remote/notice_source.dart';
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
      return await ref.read(noticeRepositoryProvider).getNoticeSaved(id);
    } on NoticeException catch (e) {
      ref
          .read(logProvider.notifier)
          .log(
            '[NoticeSaved]\n\ngetNoticeSaved failed\n\nid:\n$id\n\nError:\n$e',
          );

      return false;
    } on Exception catch (e) {
      ref
          .read(logProvider.notifier)
          .log(
            '[NoticeSaved]\n\ngetNoticeSaved failed\n\nid:\n$id\n\nError:\n$e',
          );

      rethrow;
    }
  }

  void setNoticeSaved({required bool isSaved, required String noticeId}) {
    Debounce.call(
      'setNoticeSaved',
      const Duration(milliseconds: 200),
      () async {
        if (isSaved) {
          await ref.read(noticeRepositoryProvider).saveNotice(noticeId);
        } else {
          await ref.read(noticeRepositoryProvider).deleteNotice(noticeId);
        }
        ref.read(savedNoticesProvider.notifier).refreshSavedNotices();
      },
    );
  }

  Future<void> toggleSave({
    required bool isSaved,
    required String noticeId,
  }) async {
    state = AsyncValue.data(isSaved);
    setNoticeSaved(isSaved: isSaved, noticeId: noticeId);
  }
}

final noticeSavedProvider = AsyncNotifierProvider.autoDispose
    .family<NoticeSaved, bool, String>(NoticeSaved.new);
