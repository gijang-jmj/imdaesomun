import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/text_util.dart';
import 'package:shimmer/shimmer.dart';

class InformationCard extends StatelessWidget {
  final String text;

  const InformationCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  TextUtil.keepWord(text),
                  style: AppTextStyle.subBody1.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InformationCardSkeleton extends StatelessWidget {
  const InformationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMargin.medium,
        vertical: AppMargin.small,
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.gray100,
        highlightColor: AppColors.gray200,
        child: Container(
          width: 328,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      ),
    );
  }
}
