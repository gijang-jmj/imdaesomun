import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/utils/timing_util.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';
import 'package:imdaesomun/src/data/sources/remote/notice_source.dart';
import 'package:imdaesomun/src/ui/pages/notice/notice_page_state.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticePageViewModel
    extends AutoDisposeFamilyAsyncNotifier<NoticePageState, String> {
  Future<NoticePageState> init(String id) async {
    final initialState = NoticePageState(id: id, isSaved: false);
    final notice = await ref.read(noticeRepositoryProvider).getNoticeById(id);
    final isSaved = await updateNoticeSaved(id);
    return initialState.copyWith(notice: notice, isSaved: isSaved);
  }

  @override
  Future<NoticePageState> build(String id) async {
    return await init(id);
  }

  Future<bool> updateNoticeSaved(String id) async {
    try {
      final isSaved = await ref
          .read(noticeRepositoryProvider)
          .isNoticeSaved(id);
      return isSaved;
    } on NoticeException catch (e) {
      print(e);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> openLink({required void Function(String error) onError}) async {
    final currentState = state.value;
    if (currentState == null) return;

    final url = currentState.notice?.link;
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

  void setNoticeSaved({required bool isSaved}) {
    Debounce.call('setNoticeSaved', const Duration(seconds: 1), () async {
      final currentState = state.value;
      if (currentState == null) return;

      if (isSaved) {
        await ref.read(noticeRepositoryProvider).saveNotice(currentState.id);
      } else {
        await ref.read(noticeRepositoryProvider).deleteNotice(currentState.id);
      }
    });
  }

  void toggleBookmark() async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(
      currentState.copyWith(isSaved: !currentState.isSaved),
    );

    setNoticeSaved(isSaved: !currentState.isSaved);
  }
}

final noticePageViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<NoticePageViewModel, NoticePageState, String>(
      NoticePageViewModel.new,
    );
