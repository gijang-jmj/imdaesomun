import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/switch/app_switch.dart';

class ProfileSwitchItem extends StatelessWidget {
  final String icon;
  final AsyncValue<bool> toggle;
  final VoidCallback onTap;

  const ProfileSwitchItem({
    super.key,
    required this.icon,
    required this.toggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppMargin.medium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: AppMargin.small,
              children: [
                AppIcon(
                  icon,
                  color: AppColors.teal500,
                  size: AppIconSize.medium,
                ),
                Text(
                  '공고 알림',
                  style: AppTextStyle.body1.copyWith(color: AppColors.gray900),
                ),
              ],
            ),
            toggle.when(
              data: (value) => AppSwitch(value: value),
              loading: () => AppSwitch(value: false),
              error: (error, stack) => AppSwitch(value: false),
            ),
          ],
        ),
      ),
    );
  }
}
