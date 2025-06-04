import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/text_util.dart';

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
