import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/helpers/dialog_helper.dart';
import 'package:imdaesomun/src/core/helpers/user_helper.dart';
import 'package:imdaesomun/src/core/providers/toast_provider.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/ui/pages/profile/profile_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/profile/widgets/profile_menu_item.dart';
import 'package:imdaesomun/src/ui/pages/profile/widgets/profile_switch_item.dart';
import 'package:imdaesomun/src/ui/widgets/card/login_card.dart';
import 'package:imdaesomun/src/ui/widgets/dialog/confirm_dialog.dart';
import 'package:imdaesomun/src/ui/widgets/dialog/default_input_dialog.dart';
import 'package:imdaesomun/src/ui/widgets/dialog/password_input_dialog.dart';
import 'package:imdaesomun/src/ui/widgets/login/login_dialog.dart';
import 'package:imdaesomun/src/ui/widgets/card/information_button_card.dart';

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
                  InformationButtonCard(
                    text: '이메일(${user.email})로 전송된 인증 링크를 클릭해 가입을 완료해 주세요',
                    leftText: '인증 완료',
                    rightText: '재발송',
                    onLeft: () {
                      ref
                          .read(profilePageViewModelProvider.notifier)
                          .verifyEmail(
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
                    onRight: () {
                      ref
                          .read(profilePageViewModelProvider.notifier)
                          .sendEmailVerification(
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
                // 로그인 카드
                if (user == null) const LoginCard(),
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
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: UserHelper.getNickName(user),
                                          style: AppTextStyle.body2.copyWith(
                                            color: AppColors.gray900,
                                          ),
                                        ),
                                        TextSpan(
                                          text: UserHelper.getUidShort(user),
                                          style: AppTextStyle.caption2.copyWith(
                                            color: AppColors.gray500,
                                          ),
                                        ),
                                      ],
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
                        Consumer(
                          builder: (context, ref, child) {
                            final toggle = ref.watch(
                              profilePageViewModelProvider,
                            );
                            final pushAllowed = toggle.value ?? false;
                            return ProfileSwitchItem(
                              icon: AppIcons.bell,
                              toggle: toggle,
                              onTap:
                                  () => ref
                                      .read(
                                        profilePageViewModelProvider.notifier,
                                      )
                                      .togglePushAllowed(allowed: !pushAllowed),
                            );
                          },
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: AppColors.gray100,
                        ),
                        ProfileMenuItem(
                          icon: AppIcons.edit,
                          label: '닉네임 변경',
                          onTap: () {
                            if (user == null) {
                              showCustomDialog(context, const LoginDialog());
                              return;
                            }

                            if (!user.emailVerified) {
                              ref
                                  .read(globalToastProvider.notifier)
                                  .showToast('내정보 이메일 인증 후 이용할 수 있어요');
                              return;
                            }

                            showCustomDialog(
                              context,
                              DefaultInputDialog(
                                title: '닉네임 변경',
                                hintText: '변경할 닉네임 입력해주세요',
                                maxLength: 10,
                                onConfirm: (displayName) {
                                  ref
                                      .read(
                                        profilePageViewModelProvider.notifier,
                                      )
                                      .updateDisplayName(
                                        displayName: displayName.trim(),
                                        onSuccess: (msg) {
                                          context.pop();
                                          ref
                                              .read(
                                                globalToastProvider.notifier,
                                              )
                                              .showToast(msg);
                                        },
                                        onError: (msg) {
                                          ref
                                              .read(
                                                globalToastProvider.notifier,
                                              )
                                              .showToast(msg);
                                        },
                                      );
                                },
                                onCancel: () => context.pop(),
                              ),
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
                          ProfileMenuItem(
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
                          ProfileMenuItem(
                            icon: AppIcons.delete,
                            label: '회원 탈퇴',
                            isDestructive: true,
                            onTap: () {
                              showCustomDialog(
                                context,
                                ConfirmDialog(
                                  title: '회원 탈퇴',
                                  content: '탈퇴 시 모든 데이터가 삭제됩니다.\n정말 탈퇴하시겠습니까?',
                                  rightText: '탈퇴',
                                  onRight: () {
                                    context.pop();
                                    showCustomDialog(
                                      context,
                                      PasswordInputDialog(
                                        title: '비밀번호 입력',
                                        onConfirm: (password) {
                                          ref
                                              .read(
                                                profilePageViewModelProvider
                                                    .notifier,
                                              )
                                              .deleteAccount(
                                                password: password,
                                                onSuccess: (msg) {
                                                  ref
                                                      .read(
                                                        globalToastProvider
                                                            .notifier,
                                                      )
                                                      .showToast(msg);
                                                  context.pop();
                                                },
                                                onError: (msg) {
                                                  ref
                                                      .read(
                                                        globalToastProvider
                                                            .notifier,
                                                      )
                                                      .showToast(msg);
                                                },
                                              );
                                        },
                                        onCancel: () => context.pop(),
                                      ),
                                    );
                                  },
                                  leftText: '취소',
                                  onLeft: () => context.pop(),
                                ),
                              );
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
