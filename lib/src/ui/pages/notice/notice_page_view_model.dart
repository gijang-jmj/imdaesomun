import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticePageViewModel
    extends AutoDisposeFamilyAsyncNotifier<Notice, String> {
  @override
  Future<Notice> build(String id) async {
    return await ref.read(noticeRepositoryProvider).getNoticeById(id);
  }

  Future<void> openLink({required void Function(String error) onError}) async {
    final url = state.value?.link;

    if (url == null) {
      onError('공고 원문 보기에 실패했어요\n잠시 후 다시 시도해주세요');
      return;
    }

    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      onError('공고 원문 보기에 실패했어요\n잠시 후 다시 시도해주세요');
    }
  }
}

final noticePageViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<NoticePageViewModel, Notice, String>(NoticePageViewModel.new);
