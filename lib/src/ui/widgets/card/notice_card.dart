import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class NoticeCard extends StatelessWidget {
  final String title;
  final String date;
  final String views;
  final String department;

  const NoticeCard({
    super.key,
    required this.title,
    required this.date,
    required this.views,
    required this.department,
  });

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
          spacing: AppMargin.small,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyle.subTitle2.copyWith(
                    color: AppColors.gray900,
                  ),
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
                      date,
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
                      views,
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
    );
  }
}
