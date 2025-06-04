import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/helpers/notice_helper.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/format_util.dart';
import 'package:imdaesomun/src/core/utils/text_util.dart';
import 'package:imdaesomun/src/ui/components/badge/app_text_badge.dart';
import 'package:shimmer/shimmer.dart';

class NoticeCard extends StatelessWidget {
  final String title;
  final int regDate;
  final int hits;
  final String department;
  final VoidCallback? onTap;

  const NoticeCard({
    super.key,
    required this.title,
    required this.regDate,
    required this.hits,
    required this.department,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: AppBoxShadow.large.blurRadius,
      shadowColor: AppBoxShadow.large.color,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppMargin.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppMargin.small,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppMargin.extraSmall,
                children: [
                  if (NoticeHelper.isNewNotice(regDate))
                    AppTextBadge(text: '신규'),
                  Text(
                    TextUtil.keepWord(title),
                    style: AppTextStyle.subTitle2.copyWith(
                      color: AppColors.gray900,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Row(
                spacing: AppMargin.small,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppIcon(AppIcons.date, color: AppColors.gray500),
                      const SizedBox(width: AppMargin.extraSmall),
                      Text(
                        FormatUtil.formatDate(regDate),
                        style: AppTextStyle.subBody3.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppIcon(AppIcons.view, color: AppColors.gray500),
                      const SizedBox(width: AppMargin.extraSmall),
                      Text(
                        FormatUtil.formatNumberWithComma(hits),
                        style: AppTextStyle.subBody3.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppIcon(AppIcons.department, color: AppColors.gray500),
                      const SizedBox(width: AppMargin.extraSmall),
                      Text(
                        department,
                        style: AppTextStyle.subBody3.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoticeCardSkeleton extends StatelessWidget {
  const NoticeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [AppBoxShadow.medium],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppMargin.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.gray100,
              highlightColor: AppColors.gray200,
              child: Container(
                height: 24,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: AppMargin.small),
            Row(
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.gray100,
                  highlightColor: AppColors.gray200,
                  child: Container(
                    height: 20,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: AppMargin.small),
                Shimmer.fromColors(
                  baseColor: AppColors.gray100,
                  highlightColor: AppColors.gray200,
                  child: Container(
                    height: 20,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: AppMargin.small),
                Shimmer.fromColors(
                  baseColor: AppColors.gray100,
                  highlightColor: AppColors.gray200,
                  child: Container(
                    height: 20,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
