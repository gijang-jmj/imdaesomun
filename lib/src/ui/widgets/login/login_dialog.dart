import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/providers/toast_provider.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/button/app_icon_button.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_button.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_line_button.dart';
import 'package:imdaesomun/src/ui/components/field/app_text_form_field.dart';
import 'package:imdaesomun/src/ui/widgets/login/login_dialog_view_model.dart';

class LoginDialog extends ConsumerStatefulWidget {
  const LoginDialog({super.key});

  @override
  ConsumerState<LoginDialog> createState() => _LoginAlertState();
}

class _LoginAlertState extends ConsumerState<LoginDialog> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginDialogViewModelProvider);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppMargin.medium),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [AppBoxShadow.medium],
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppMargin.medium),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    spacing: AppMargin.medium,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: AppMargin.small,
                        children: [
                          const AppIcon(
                            AppIcons.homeFill,
                            size: AppIconSize.medium,
                            color: AppColors.teal500,
                          ),
                          Text(
                            '임대소문',
                            style: AppTextStyle.subTitle1.copyWith(
                              color: AppColors.gray900,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppMargin.small,
                        children: [
                          Text(
                            '이메일',
                            style: AppTextStyle.subBody3.copyWith(
                              color: AppColors.gray900,
                            ),
                          ),
                          AppTextFormField(
                            formKey: _emailFieldKey,
                            controller: _emailController,
                            hintText: 'example@email.com',
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                ref
                                    .read(loginDialogViewModelProvider.notifier)
                                    .emailValidator,
                            suffixIcon: const AppIconButton(
                              icon: AppIcon(
                                AppIcons.mail,
                                size: AppIconSize.medium,
                              ),
                              onPressed: null,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppMargin.small,
                        children: [
                          Text(
                            '비밀번호',
                            style: AppTextStyle.subBody3.copyWith(
                              color: AppColors.gray900,
                            ),
                          ),
                          AppTextFormField(
                            controller: _passwordController,
                            hintText: '비밀번호 입력',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: viewModel.obscure,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator:
                                ref
                                    .read(loginDialogViewModelProvider.notifier)
                                    .passwordValidator,
                            suffixIcon: AppIconButton(
                              icon: AppIcon(
                                viewModel.obscure
                                    ? AppIcons.viewOff
                                    : AppIcons.view,
                                size: AppIconSize.medium,
                              ),
                              onPressed:
                                  () =>
                                      ref
                                          .read(
                                            loginDialogViewModelProvider
                                                .notifier,
                                          )
                                          .toggleObscure(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: AppMargin.small,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_emailFieldKey.currentState!.validate()) {
                                ref
                                    .read(loginDialogViewModelProvider.notifier)
                                    .resetPassword(
                                      email: _emailController.text.trim(),
                                      onSuccess: (msg) {
                                        ref
                                            .read(globalToastProvider.notifier)
                                            .showToast(msg);
                                        context.pop();
                                      },
                                      onError: (msg) {
                                        ref
                                            .read(globalToastProvider.notifier)
                                            .showToast(msg);
                                      },
                                    );
                              }
                            },
                            child: Text(
                              '비밀번호 재설정',
                              style: AppTextStyle.caption1.copyWith(
                                color: AppColors.teal500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: AppMargin.small,
                        children: [
                          Expanded(
                            child: AppTextButton(
                              text: '로그인',
                              textStyle: AppTextStyle.body1,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(
                                        loginDialogViewModelProvider.notifier,
                                      )
                                      .onLogin(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                        onSuccess: (msg) {
                                          ref
                                              .read(
                                                globalToastProvider.notifier,
                                              )
                                              .showToast(msg);
                                          context.pop();
                                        },
                                        onError: (msg) {
                                          ref
                                              .read(
                                                globalToastProvider.notifier,
                                              )
                                              .showToast(msg);
                                        },
                                      );
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: AppTextLineButton(
                              text: '회원가입',
                              textStyle: AppTextStyle.body1,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(
                                        loginDialogViewModelProvider.notifier,
                                      )
                                      .onSignUp(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                        onSuccess: (msg) {
                                          ref
                                              .read(
                                                globalToastProvider.notifier,
                                              )
                                              .showToast(msg);
                                          context.pop();
                                        },
                                        onError: (msg) {
                                          ref
                                              .read(
                                                globalToastProvider.notifier,
                                              )
                                              .showToast(msg);
                                        },
                                      );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
