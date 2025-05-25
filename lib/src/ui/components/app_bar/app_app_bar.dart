import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? title;
  final Color backgroundColor;
  final double height;
  final bool showBackButton;

  const AppAppBar({
    super.key,
    this.onBackPressed,
    this.actions,
    this.title,
    this.backgroundColor = Colors.white,
    this.height = AppBarHeight.medium,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [AppBoxShadow.medium],
      ),
      child: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: title,
        titleTextStyle: AppTextStyle.title2.copyWith(color: AppColors.gray900),
        leading:
            showBackButton
                ? IconButton(
                  icon: const AppIcon(
                    AppIcons.back,
                    size: AppIconSize.medium,
                    color: AppColors.gray900,
                  ),
                  onPressed: onBackPressed ?? () => context.pop(),
                )
                : null,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
