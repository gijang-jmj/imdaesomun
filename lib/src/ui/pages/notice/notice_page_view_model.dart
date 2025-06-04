import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/utils/timing_util.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';
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
    return await ref.read(noticeRepositoryProvider).isNoticeSaved(id);
  }

  void setNoticeSaved({required bool isSaved, required String noticeId}) {
    Debounce.call('setNoticeSaved', const Duration(seconds: 1), () async {
      if (isSaved) {
        await ref.read(noticeRepositoryProvider).saveNotice(noticeId);
      } else {
        await ref.read(noticeRepositoryProvider).deleteNotice(noticeId);
      }
    });
  }

  Future<void> toggleBookmark({
    required bool isSaved,
    required String noticeId,
  }) async {
    state = AsyncValue.data(isSaved);
    setNoticeSaved(isSaved: isSaved, noticeId: noticeId);
  }
}

final noticeSavedProvider = AsyncNotifierProvider.autoDispose
    .family<NoticeSaved, bool, String>(NoticeSaved.new);
