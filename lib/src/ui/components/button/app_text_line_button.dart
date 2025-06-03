import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class AppTextLineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final VoidCallback? onDisabledPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final MaterialTapTargetSize? tapTargetSize;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? iconSpacing;
  final Widget? child;

  const AppTextLineButton({
    super.key,
    this.text = '',
    this.onPressed,
    this.onDisabledPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = AppColors.teal500,
    this.disabledBackgroundColor = AppColors.teal200,
    this.disabledForegroundColor = Colors.white,
    this.textStyle = AppTextStyle.subTitle2,
    this.width = double.infinity,
    this.height = AppButtonHeight.medium,
    this.padding = AppEdgeInsets.bottomButtonPadding,
    this.minimumSize = const Size(0, 0),
    this.tapTargetSize = MaterialTapTargetSize.shrinkWrap,
    this.borderRadius,
    this.borderColor = AppColors.teal500,
    this.borderWidth,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSpacing = AppMargin.extraSmall,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap:
            onPressed == null && onDisabledPressed != null
                ? onDisabledPressed
                : null,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            disabledBackgroundColor: disabledBackgroundColor,
            disabledForegroundColor: disabledForegroundColor,
            padding: padding,
            minimumSize: minimumSize,
            tapTargetSize: tapTargetSize,
            shape: RoundedRectangleBorder(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(AppRadius.medium),
              side:
                  borderColor != null
                      ? BorderSide(
                        color: borderColor!,
                        width: borderWidth ?? 1.0,
                      )
                      : BorderSide.none,
            ),
            textStyle: textStyle,
          ),
          onPressed: onPressed,
          child:
              child ??
              ((prefixIcon != null || suffixIcon != null)
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) prefixIcon!,
                      if (prefixIcon != null) SizedBox(width: iconSpacing),
                      Text(text),
                      if (suffixIcon != null) SizedBox(width: iconSpacing),
                      if (suffixIcon != null) suffixIcon!,
                    ],
                  )
                  : Text(text)),
        ),
      ),
    );
  }
}
