import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/providers/navigation_provider.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_button_card.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_card.dart';

class SavedTop extends ConsumerWidget {
  const SavedTop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedNotices = ref.watch(savedNoticesProvider).value;

    return savedNotices != null && savedNotices.notices.isEmpty
        ? InformationButtonCard(
          text: '저장된 공고가 없어요\n관심 있는 공고를 저장할 수 있어요',
          leftText: '공고 보러가기',
          rightText: '새로고침',
          onLeft: () {
            ref.read(navigationShellProvider)?.goBranch(0);
          },
          onRight: () {
            ref.read(savedNoticesProvider.notifier).refreshSavedNotices();
          },
        )
        : const InformationCard(text: '최근에 저장된 공고순으로 저장되어 있어요');
  }
}
