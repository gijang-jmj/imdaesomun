import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/text_util.dart';
import 'package:imdaesomun/src/ui/widgets/footer/copyright_footer.dart';
import 'package:imdaesomun/src/ui/widgets/card/notice_card.dart';
import 'package:imdaesomun/src/ui/pages/home/home_page_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [AppBoxShadow.medium],
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppMargin.medium),
                    child: Row(
                      spacing: AppMargin.small,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const AppIcon(
                          AppIcons.homeFill,
                          size: AppIconSize.medium,
                          color: AppColors.teal500,
                        ),
                        Expanded(
                          child: Text(
                            TextUtil.keepWord(
                              '최근 10개 공고만 제공되며, 과거 공고 및 검색·정렬 기능은 각 공사의 공식 홈페이지를 이용해주세요',
                            ),
                            style: AppTextStyle.subBody1.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Column(
                  spacing: AppMargin.small,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon(
                          AppIcons.sh,
                          size: AppIconSize.extraLarge,
                          special: true,
                        ),
                        const SizedBox(width: AppMargin.extraSmall),
                        Text(
                          CorporationType.sh.korean,
                          style: AppTextStyle.title1.copyWith(
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final shNotices = ref.watch(shNoticesProvider);
                        return shNotices.when(
                          loading:
                              () => Column(
                                spacing: AppMargin.small,
                                children: const [
                                  NoticeCardSkeleton(),
                                  NoticeCardSkeleton(),
                                  NoticeCardSkeleton(),
                                ],
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
                                          ),
                                        )
                                        .toList(),
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Column(
                  spacing: AppMargin.small,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon(
                          AppIcons.gh,
                          size: AppIconSize.extraLarge,
                          special: true,
                        ),
                        const SizedBox(width: AppMargin.extraSmall),
                        Text(
                          CorporationType.gh.korean,
                          style: AppTextStyle.title1.copyWith(
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final ghNotices = ref.watch(ghNoticesProvider);
                        return ghNotices.when(
                          loading:
                              () => Column(
                                spacing: AppMargin.small,
                                children: const [
                                  NoticeCardSkeleton(),
                                  NoticeCardSkeleton(),
                                  NoticeCardSkeleton(),
                                ],
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
                                          ),
                                        )
                                        .toList(),
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppMargin.extraLarge),
              const CopyrightFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
