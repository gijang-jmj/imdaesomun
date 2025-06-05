import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/helpers/dialog_helper.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/widgets/login/login_dialog.dart';

class LoginCard extends StatelessWidget {
  final String? title;
  final String? description;

  const LoginCard({super.key, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMargin.medium,
        vertical: AppMargin.small,
      ),
      child: Material(
        color: Colors.white,
        elevation: AppBoxShadow.large.blurRadius,
        shadowColor: AppBoxShadow.large.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          side: BorderSide(color: AppColors.teal500, width: 1),
        ),
        child: InkWell(
          splashColor: AppColors.teal500WithOpacity10,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          onTap: () => showCustomDialog(context, const LoginDialog()),
          child: Padding(
            padding: const EdgeInsets.all(AppIconSize.medium),
            child: Column(
              spacing: AppMargin.medium,
              children: [
                AppIcon(
                  AppIcons.homeFill,
                  size: AppIconSize.large,
                  color: AppColors.teal500,
                ),
                Text(
                  title ?? '로그인',
                  style: AppTextStyle.title1.copyWith(color: AppColors.gray900),
                ),
                Text(
                  textAlign: TextAlign.center,
                  description ?? '다양한 서비스 이용하려면 로그인 해주세요',
                  style: AppTextStyle.subBody2.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
