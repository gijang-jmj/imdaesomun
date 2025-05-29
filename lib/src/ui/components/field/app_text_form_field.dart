import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final int? maxLength;

  const AppTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.autovalidateMode,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    Widget? customCounter =
        maxLength != null && controller != null
            ? Padding(
              padding: EdgeInsets.only(right: 16),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyle.caption2, // Default style for the counter
                  children: <TextSpan>[
                    TextSpan(
                      text: '${controller!.text.length}',
                      style: TextStyle(
                        color: AppColors.gray800,
                      ), // Color for the length
                    ),
                    TextSpan(
                      text: '/$maxLength',
                      style: TextStyle(
                        color: AppColors.gray300,
                      ), // Color for the max length part
                    ),
                  ],
                ),
              ),
            )
            : null;

    Widget? customPrefixIcon = prefixIcon;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: autovalidateMode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          cursorColor: AppColors.teal500,
          cursorErrorColor: Colors.red,
          style: AppTextStyle.body2.copyWith(
            color: AppColors.gray900,
            decoration: TextDecoration.none,
            decorationColor: Colors.transparent,
            decorationThickness: 0.0,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: hintText,
            hintStyle: AppTextStyle.body2.copyWith(color: AppColors.gray400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: AppColors.gray200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: AppColors.teal500, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            suffixIcon: maxLength != null ? customCounter : suffixIcon,
            prefixIcon: customPrefixIcon,
            counterText: '', // Hide the default counter
          ),
        ),
      ),
    );
  }
}
