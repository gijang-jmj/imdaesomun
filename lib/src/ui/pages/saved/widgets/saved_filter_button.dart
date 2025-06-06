import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_button.dart';

class SavedFilterButton extends StatelessWidget {
  final String groupValue;
  final String value;
  final String text;
  final VoidCallback? onPressed;

  const SavedFilterButton({
    super.key,
    required this.groupValue,
    required this.value,
    required this.text,
    this.onPressed,
  });

  get isSelected => groupValue == value;

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      width: null,
      height: AppButtonHeight.extraSmall,
      padding: EdgeInsets.symmetric(horizontal: AppMargin.medium),
      borderRadius: BorderRadius.circular(AppRadius.large),
      text: text,
      textStyle: AppTextStyle.subBody1,
      onPressed: onPressed,
      backgroundColor:
          isSelected
              ? AppColors.teal500WithOpacity10
              : AppColors.gray500WithOpacity10,
      foregroundColor: isSelected ? AppColors.teal500 : AppColors.gray500,
    );
  }
}
