import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_button.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_line_button.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final String leftText;
  final String rightText;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.onLeft = _defaultOnPressed,
    this.onRight = _defaultOnPressed,
    this.leftText = '예',
    this.rightText = '아니요',
  });

  static void _defaultOnPressed() {}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppMargin.extraLarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: AppTextStyle.subTitle1.copyWith(
                  color: AppColors.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppMargin.medium),
              Text(
                content,
                style: AppTextStyle.body2.copyWith(color: AppColors.gray700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppMargin.large),
              Row(
                children: [
                  Expanded(
                    child: AppTextButton(
                      text: leftText,
                      textStyle: AppTextStyle.body1,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppMargin.small,
                      ),
                      onPressed: onLeft,
                    ),
                  ),
                  const SizedBox(width: AppMargin.small),
                  Expanded(
                    child: AppTextLineButton(
                      text: rightText,
                      textStyle: AppTextStyle.body1,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppMargin.small,
                      ),
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
