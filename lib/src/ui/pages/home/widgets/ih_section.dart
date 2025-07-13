import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/ih_title.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/notice_card.dart';
import 'package:imdaesomun/src/ui/widgets/error/default_error.dart';

class IhSection extends ConsumerWidget {
  final int index;

  const IhSection({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReorderMode = ref.watch(reorderModeProvider);

    return Padding(
      padding: const EdgeInsets.all(AppMargin.medium),
      child: Column(
        spacing: AppMargin.small,
        children: [
          if (isReorderMode)
            ReorderableDragStartListener(
              index: index,
              child: const IhTitle(isReorderMode: true),
            ),
          if (!isReorderMode)
            IhTitle(
              isReorderMode: false,
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(reorderModeProvider.notifier).state = true;
              },
            ),
          if (!isReorderMode)
            Consumer(
              builder: (context, ref, _) {
                final ihNotices = ref.watch(ihNoticesProvider);
                return ihNotices.when(
                  loading:
                      () => Column(
                        spacing: AppMargin.small,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          10,
                          (index) => const NoticeCardSkeleton(),
                        ),
                      ),
                  error: (e, st) => DefaultError(message: '공고 불러오기에 실패했어요'),
                  data:
                      (notices) => Column(
                        spacing: AppMargin.small,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:
                            notices
                                .map(
                                  (notice) => NoticeCard(
                                    title: notice.title,
                                    regDate: notice.regDate,
                                    hits: notice.hits,
                                    department: notice.department,
                                    onTap: () {
                                      context.push(
                                        '${RouterPathConstant.notice.path}/${notice.id}',
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                );
              },
            ),
        ],
      ),
    );
  }
}
