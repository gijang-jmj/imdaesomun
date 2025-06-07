import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class DefaultError extends StatelessWidget {
  final String? message;

  const DefaultError({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppMargin.medium),
      child: Row(
        spacing: AppMargin.small,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppIcon(
            AppIcons.error,
            size: AppIconSize.medium,
            color: AppColors.gray500,
          ),
          Text(
            message ?? '오류가 발생했어요\n잠시 후 다시 시도해주세요',
            style: AppTextStyle.body1.copyWith(color: AppColors.gray500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
