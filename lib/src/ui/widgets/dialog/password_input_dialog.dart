import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_button.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_line_button.dart';
import 'package:imdaesomun/src/ui/components/button/app_icon_button.dart';
import 'package:imdaesomun/src/ui/components/field/app_text_form_field.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';

class PasswordInputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final void Function(String password) onConfirm;
  final VoidCallback? onCancel;

  const PasswordInputDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    this.hintText = '비밀번호 입력',
    this.onCancel = _defaultOnPressed,
  });

  static void _defaultOnPressed() {}

  @override
  State<PasswordInputDialog> createState() => _PasswordInputDialogState();
}

class _PasswordInputDialogState extends State<PasswordInputDialog> {
  late TextEditingController _controller;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppMargin.extraLarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [AppBoxShadow.medium],
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppMargin.medium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: AppTextStyle.subTitle1.copyWith(
                  color: AppColors.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppMargin.medium),
              AppTextFormField(
                controller: _controller,
                hintText: widget.hintText,
                obscureText: _obscure,
                suffixIcon: AppIconButton(
                  icon: AppIcon(
                    _obscure ? AppIcons.viewOff : AppIcons.view,
                    size: AppIconSize.medium,
                  ),
                  onPressed: _toggleObscure,
                ),
              ),
              const SizedBox(height: AppMargin.large),
              Row(
                children: [
                  Expanded(
                    child: AppTextButton(
                      text: '확인',
                      textStyle: AppTextStyle.body1,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppMargin.small,
                      ),
                      onPressed: () {
                        widget.onConfirm(_controller.text);
                      },
                    ),
                  ),
                  const SizedBox(width: AppMargin.small),
                  Expanded(
                    child: AppTextLineButton(
                      text: '취소',
                      textStyle: AppTextStyle.body1,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppMargin.small,
                      ),
                      onPressed: () {
                        widget.onCancel?.call();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
