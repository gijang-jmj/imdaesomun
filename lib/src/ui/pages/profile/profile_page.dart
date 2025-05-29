import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/helpers/dialog_helper.dart';
import 'package:imdaesomun/src/core/helpers/user_helper.dart';
import 'package:imdaesomun/src/core/services/toast_service.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/utils/text_util.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/ui/components/switch/app_switch.dart';
import 'package:imdaesomun/src/ui/pages/profile/profile_page_view_model.dart';
import 'package:imdaesomun/src/ui/widgets/login/login_dialog.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppStatusBarStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 이메일 인증 안내
                if (user != null && !user.emailVerified)
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
                          spacing: AppMargin.medium,
                          children: [
                            Row(
                              spacing: AppMargin.small,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const AppIcon(
                                  AppIcons.homeFill,
                                  size: AppIconSize.medium,
                                  color: AppColors.teal500,
                                ),
                                Expanded(
                                  child: Text(
                                    TextUtil.keepWord(
                                      '"${user.email}"로 전송된 이메일 인증을 완료해주세요',
                                    ),
                                    style: AppTextStyle.subBody1.copyWith(
                                      color: AppColors.gray500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Text(
                                    '인증 완료',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.caption1.copyWith(
                                      color: AppColors.teal500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '재발송',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.caption1.copyWith(
                                      color: AppColors.teal500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // 로그인 카드
                if (user == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppMargin.medium,
                      vertical: AppMargin.small,
                    ),
                    child: Material(
                      color: Colors.white,
                      elevation: AppBoxShadow.large.blurRadius,
                      shadowColor: AppBoxShadow.large.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        side: BorderSide(color: AppColors.teal500, width: 1),
                      ),
                      child: InkWell(
                        splashColor: AppColors.teal500WithOpacity10,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        onTap:
                            () =>
                                showCustomDialog(context, const LoginDialog()),
                        child: Padding(
                          padding: const EdgeInsets.all(AppIconSize.medium),
                          child: Column(
                            spacing: AppMargin.medium,
                            children: [
                              AppIcon(
                                AppIcons.homeFill,
                                size: AppIconSize.large,
                                color: AppColors.teal500,
                              ),
                              Text(
                                '로그인',
                                style: AppTextStyle.title1.copyWith(
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
                        ),
                      ),
                    ),
                  ),
                // 유저 카드
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '닉네임',
                                    style: AppTextStyle.subBody2.copyWith(
                                      color: AppColors.gray500,
                                    ),
                                  ),
                                  Text(
                                    UserHelper.generateUserName(user),
                                    style: AppTextStyle.body2.copyWith(
                                      color: AppColors.gray900,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '이메일',
                                    style: AppTextStyle.subBody2.copyWith(
                                      color: AppColors.gray500,
                                    ),
                                  ),
                                  Text(
                                    user?.email ?? 'guest@imdaesomun.com',
                                    style: AppTextStyle.body2.copyWith(
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
                // 회원 메뉴
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
                        InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          onTap: () => {print('알림 설정 클릭')},
                          child: Padding(
                            padding: const EdgeInsets.all(AppMargin.medium),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: AppMargin.small,
                                  children: [
                                    const AppIcon(
                                      AppIcons.bell,
                                      color: AppColors.teal500,
                                      size: AppIconSize.medium,
                                    ),
                                    Text(
                                      '공고 알림',
                                      style: AppTextStyle.body1.copyWith(
                                        color: AppColors.gray900,
                                      ),
                                    ),
                                  ],
                                ),
                                AppSwitch(value: false),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: AppColors.gray100,
                        ),
                        _ProfileMenuItem(
                          icon: AppIcons.edit,
                          label: '닉네임 변경',
                          onTap: () {
                            if (user != null && !user.emailVerified) {
                              ref
                                  .read(globalToastProvider.notifier)
                                  .showToast('이메일 인증을 완료해주세요');
                              return;
                            }

                            ref
                                .read(profilePageViewModelProvider.notifier)
                                .updateDisplayName(
                                  displayName: '주민종종맨2234',
                                  onSuccess: (msg) {
                                    ref
                                        .read(globalToastProvider.notifier)
                                        .showToast(msg);
                                  },
                                  onError: (msg) {
                                    ref
                                        .read(globalToastProvider.notifier)
                                        .showToast(msg);
                                  },
                                );
                          },
                        ),
                        if (user != null)
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: AppColors.gray100,
                          ),
                        if (user != null)
                          _ProfileMenuItem(
                            icon: AppIcons.out,
                            label: '로그아웃',
                            onTap:
                                () => ref
                                    .read(profilePageViewModelProvider.notifier)
                                    .signOut(
                                      onSuccess: (msg) {
                                        ref
                                            .read(globalToastProvider.notifier)
                                            .showToast(msg);
                                      },
                                      onError: (msg) {
                                        ref
                                            .read(globalToastProvider.notifier)
                                            .showToast(msg);
                                      },
                                    ),
                          ),
                      ],
                    ),
                  ),
                ),
                // 회원 탈퇴 메뉴
                if (user != null)
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
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: AppColors.gray100,
                          ),
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
              ],
            ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: AppMargin.small,
              children: [
                AppIcon(
                  icon,
                  size: AppIconSize.medium,
                  color: destructiveColor,
                ),
                Text(
                  label,
                  style: AppTextStyle.body1.copyWith(color: textColor),
                ),
              ],
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}
