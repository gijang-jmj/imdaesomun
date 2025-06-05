import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class ShBanner extends StatelessWidget {
  const ShBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppIcon(AppIcons.sh, size: AppIconSize.extraLarge, special: true),
        const SizedBox(width: AppMargin.extraSmall),
        Text(
          CorporationType.sh.korean,
          style: AppTextStyle.title1.copyWith(color: AppColors.gray900),
        ),
      ],
    );
  }
}
