import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';

class AppIconActiveButton extends StatelessWidget {
  final Widget icon;
  final Widget activeIcon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final EdgeInsetsGeometry padding;
  final Size minimumSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? height;
  final bool isActive;
  final BorderRadiusGeometry? borderRadius;

  const AppIconActiveButton({
    super.key,
    required this.isActive,
    required this.icon,
    required this.activeIcon,
    required this.onPressed,
    this.tooltip,
    this.padding = AppEdgeInsets.bottomButtonPadding,
    this.minimumSize = Size.zero,
    this.backgroundColor,
    this.iconColor,
    this.height = AppButtonHeight.medium,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: IconButton(
        icon: isActive ? activeIcon : icon,
        onPressed: onPressed,
        tooltip: tooltip,
        color: isActive ? AppColors.teal500 : AppColors.gray500,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: WidgetStateProperty.all<EdgeInsets>(padding as EdgeInsets),
          minimumSize: WidgetStateProperty.all<Size>(minimumSize),
          backgroundColor: WidgetStateProperty.all<Color>(
            isActive ? AppColors.teal500WithOpacity10 : AppColors.gray200,
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(AppRadius.medium),
            ),
          ),
        ),
      ),
    );
  }
}
