import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_button.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_line_button.dart';
import 'package:imdaesomun/src/ui/components/field/app_text_form_field.dart';

class DefaultInputDialog extends StatefulWidget {
  final String title;
  final String? hintText;
  final void Function(String input) onConfirm;
  final VoidCallback? onCancel;
  final int? maxLength;

  const DefaultInputDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    this.hintText,
    this.onCancel = _defaultOnPressed,
    this.maxLength,
  });

  static void _defaultOnPressed() {}

  @override
  State<DefaultInputDialog> createState() => _DefaultInputDialogState();
}

class _DefaultInputDialogState extends State<DefaultInputDialog> {
  late TextEditingController _controller;
  String textValue = '';

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
                maxLength: widget.maxLength,
                onChanged: (value) {
                  setState(() {
                    textValue = value;
                  });
                },
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
