import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/providers/notice_provider.dart';

class NoticePageViewModel
    extends AutoDisposeFamilyAsyncNotifier<Notice, String> {
  @override
  Future<Notice> build(String id) async {
    return await ref.read(noticeProvider).getNoticeById(id);
  }
}

final noticePageViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<NoticePageViewModel, Notice, String>(NoticePageViewModel.new);
