import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/text_util.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_line_button.dart';

class InformationButtonCard extends StatelessWidget {
  final String text;
  final String leftText;
  final String rightText;
  final String? icon;
  final Color? iconColor;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const InformationButtonCard({
    super.key,
    required this.text,
    required this.leftText,
    required this.rightText,
    required this.onLeft,
    required this.onRight,
    this.icon,
    this.iconColor = AppColors.teal500,
  });

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
          child: Column(
            children: [
              Row(
                children: [
                  AppIcon(
                    icon ?? AppIcons.homeFill,
                    size: AppIconSize.medium,
                    color: iconColor,
                  ),
                  const SizedBox(width: AppMargin.small),
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
              const SizedBox(height: AppMargin.medium),
              Row(
                spacing: AppMargin.small,
                children: [
                  Expanded(
                    child: AppTextLineButton(
                      height: AppButtonHeight.extraSmall,
                      text: leftText,
                      textStyle: AppTextStyle.subBody3,
                      onPressed: onLeft,
                    ),
                  ),
                  Expanded(
                    child: AppTextLineButton(
                      height: AppButtonHeight.extraSmall,
                      text: rightText,
                      textStyle: AppTextStyle.subBody3,
                      onPressed: onRight,
                    ),
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
