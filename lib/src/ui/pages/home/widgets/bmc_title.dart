import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/button/app_icon_button.dart';

class BmcTitle extends StatelessWidget {
  final bool isReorderMode;
  final VoidCallback? onPressed;

  const BmcTitle({super.key, required this.isReorderMode, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            spacing: AppMargin.extraSmall,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/bmc.png', width: 30),
              Expanded(
                child: Text(
                  CorporationType.bmc.korean,
                  style: AppTextStyle.title1.copyWith(color: AppColors.gray900),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        AppIconButton(
          minimumSize: const Size(28, 28),
          icon: AppIcon(
            isReorderMode ? AppIcons.change : AppIcons.order,
            size: AppIconSize.large,
            color: AppColors.teal500,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
