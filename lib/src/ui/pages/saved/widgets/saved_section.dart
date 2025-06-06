import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_line_button.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/saved/widgets/saved_card.dart';

class SavedSection extends ConsumerWidget {
  final bool isLoadingMore;
  final VoidCallback onPressed;

  const SavedSection({
    super.key,
    required this.isLoadingMore,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedNotices = ref.watch(savedNoticesProvider);

    return savedNotices.when(
      loading:
          () => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppMargin.medium,
              vertical: AppMargin.small,
            ),
            child: Column(
              spacing: AppMargin.small,
              children: List.generate(10, (index) => const SavedCardSkeleton()),
            ),
          ),
      error: (e, st) => Center(child: Text('오류: $e')),
      data:
          (page) =>
              page.notices.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppMargin.medium,
                      vertical: AppMargin.small,
                    ),
                    child: Column(
                      spacing: AppMargin.small,
                      children: [
                        ...page.notices.map(
                          (notice) => SavedCard(
                            title: notice.title,
                            regDate: notice.regDate,
                            hits: notice.hits,
                            department: notice.department,
                            corporation: notice.corporation,
                            onTap: () {
                              context.push(
                                '${RouterPathConstant.notice.path}/${notice.id}',
                              );
                            },
                          ),
                        ),
                        // 더보기 버튼 또는 로딩 인디케이터
                        if (page.hasMore)
                          Padding(
                            padding: const EdgeInsets.all(AppMargin.medium),
                            child: Center(
                              child:
                                  isLoadingMore
                                      ? const CircularProgressIndicator()
                                      : AppTextLineButton(
                                        width: null,
                                        height: AppButtonHeight.extraSmall,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppMargin.medium,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.extraLarge,
                                        ),
                                        onPressed: onPressed,
                                        text: '더보기',
                                        textStyle: AppTextStyle.subBody1,
                                      ),
                            ),
                          ),
                      ],
                    ),
                  )
                  : const SizedBox(),
    );
  }
}
