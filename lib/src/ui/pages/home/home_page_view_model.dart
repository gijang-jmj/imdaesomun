import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/providers/notice_provider.dart';

class ShNotices extends AsyncNotifier<List<Notice>> {
  @override
  Future<List<Notice>> build() async {
    return await ref.read(noticeProvider).getShNotices();
  }
}

final shNoticesProvider = AsyncNotifierProvider<ShNotices, List<Notice>>(
  ShNotices.new,
);

class GhNotices extends AsyncNotifier<List<Notice>> {
  @override
  Future<List<Notice>> build() async {
    return await ref.read(noticeProvider).getGhNotices();
  }
}

final ghNoticesProvider = AsyncNotifierProvider<GhNotices, List<Notice>>(
  GhNotices.new,
);
