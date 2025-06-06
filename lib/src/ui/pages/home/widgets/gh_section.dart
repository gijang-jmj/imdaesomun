import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/gh_title.dart';
import 'package:imdaesomun/src/ui/pages/home/widgets/notice_card.dart';

class GhSection extends ConsumerWidget {
  const GhSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReorderMode = ref.watch(reorderModeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMargin.medium,
        vertical: AppMargin.small,
      ),
      child: Column(
        spacing: AppMargin.small,
        children: [
          if (isReorderMode)
            ReorderableDragStartListener(
              index: 1,
              child: const GhTitle(isReorderMode: true),
            ),
          if (!isReorderMode)
            GhTitle(
              isReorderMode: false,
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(reorderModeProvider.notifier).state = true;
              },
            ),
          if (!isReorderMode)
            Consumer(
              builder: (context, ref, _) {
                final ghNotices = ref.watch(ghNoticesProvider);
                return ghNotices.when(
                  loading:
                      () => Column(
                        spacing: AppMargin.small,
                        children: List.generate(
                          10,
                          (index) => const NoticeCardSkeleton(),
                        ),
                      ),
                  error: (e, st) => Center(child: Text('오류: $e')),
                  data:
                      (notices) => Column(
                        spacing: AppMargin.small,
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
