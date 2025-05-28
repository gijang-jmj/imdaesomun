import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/ui/widgets/footer/copyright_footer.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = FirebaseAuth.instance.currentUser;
    final nickname = '주민종';
    final email = 'user@example.com';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppStatusBarStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        body: SafeArea(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              // 미 로그인 상태
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [AppBoxShadow.medium],
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(color: AppColors.teal500, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppMargin.medium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          spacing: AppMargin.medium,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '로그인',
                              style: AppTextStyle.body1.copyWith(
                                color: AppColors.gray900,
                              ),
                            ),
                            Text(
                              '다양한 서비스 이용하려면 로그인 해주세요',
                              style: AppTextStyle.subBody2.copyWith(
                                color: AppColors.gray500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 상단 닉네임/이메일 카드
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          spacing: AppMargin.medium,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '닉네임',
                                  style: AppTextStyle.subBody2.copyWith(
                                    color: AppColors.gray500,
                                  ),
                                ),
                                Text(
                                  nickname,
                                  style: AppTextStyle.body1.copyWith(
                                    color: AppColors.gray900,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '이메일',
                                  style: AppTextStyle.subBody2.copyWith(
                                    color: AppColors.gray500,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: AppTextStyle.body1.copyWith(
                                    color: AppColors.gray900,
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
              // 메뉴 카드
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Material(
                  color: Colors.white,
                  elevation: AppBoxShadow.large.blurRadius,
                  shadowColor: AppBoxShadow.large.color,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: AppIcons.edit,
                        label: '닉네임 변경',
                        onTap: () {
                          print('닉네임 변경');
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppColors.gray100,
                      ),
                      _ProfileMenuItem(
                        icon: AppIcons.bookmark,
                        label: '저장된 공고',
                        onTap: () {
                          print('저장된 공고');
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppColors.gray100,
                      ),
                      _ProfileMenuItem(
                        icon: AppIcons.post,
                        label: '작성한 게시글',
                        onTap: () {
                          print('작성한 게시글');
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppColors.gray100,
                      ),
                      _ProfileMenuItem(
                        icon: AppIcons.comment,
                        label: '작성한 댓글',
                        onTap: () {
                          print('작성한 댓글');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMargin.medium,
                  vertical: AppMargin.small,
                ),
                child: Material(
                  color: Colors.white,
                  elevation: AppBoxShadow.large.blurRadius,
                  shadowColor: AppBoxShadow.large.color,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: AppIcons.delete,
                        label: '회원 탈퇴',
                        isDestructive: true,
                        onTap: () {
                          print('회원 탈퇴');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppMargin.extraLarge),
              const CopyrightFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final destructiveColor = isDestructive ? Colors.red : AppColors.teal500;
    final textColor = isDestructive ? Colors.red : AppColors.gray900;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppMargin.medium),
        child: Row(
          children: [
            AppIcon(icon, size: AppIconSize.medium, color: destructiveColor),
            const SizedBox(width: AppMargin.small),
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.body1.copyWith(color: textColor),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}
