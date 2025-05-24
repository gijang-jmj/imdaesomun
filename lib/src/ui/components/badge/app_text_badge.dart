import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class AppTextBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;

  const AppTextBadge({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.teal500WithOpacity10,
    this.padding,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.medium),
      ),
      child: Text(
        text,
        style:
            textStyle ??
            AppTextStyle.caption1.copyWith(color: AppColors.teal500),
      ),
    );
  }
}
