import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_button.dart';

class LoginAlert extends StatefulWidget {
  final void Function(String email, String password) onLogin;
  final void Function(String email, String password) onSignUp;

  const LoginAlert({super.key, required this.onLogin, required this.onSignUp});

  @override
  State<LoginAlert> createState() => _LoginAlertState();
}

class _LoginAlertState extends State<LoginAlert> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('로그인/회원가입', style: AppTextStyle.title2),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '이메일',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: '비밀번호',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppTextButton(
                text: '로그인',
                onPressed: () {
                  widget.onLogin(
                    _emailController.text.trim(),
                    _passwordController.text,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppTextButton(
                text: '회원가입',
                backgroundColor: AppColors.gray200,
                foregroundColor: AppColors.gray900,
                onPressed: () {
                  widget.onSignUp(
                    _emailController.text.trim(),
                    _passwordController.text,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
