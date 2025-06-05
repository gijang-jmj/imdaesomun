import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/helpers/dialog_helper.dart';
import 'package:imdaesomun/src/core/services/toast_service.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';
import 'package:imdaesomun/src/ui/components/button/app_icon_active_button.dart';
import 'package:imdaesomun/src/ui/pages/notice/notice_page_view_model.dart';
import 'package:imdaesomun/src/ui/widgets/login/login_dialog.dart';

class NoticeSaveButton extends ConsumerWidget {
  final String noticeId;

  const NoticeSaveButton({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final notice = ref.watch(noticeSavedProvider(noticeId));

    return notice.when(
      data: (isSaved) {
        return AppIconActiveButton(
          isActive: isSaved,
          icon: AppIcon(AppIcons.bookmark, size: AppIconSize.medium),
          activeIcon: AppIcon(AppIcons.bookmarkCheck, size: AppIconSize.medium),
          onPressed: () {
            if (user == null) {
              ref
                  .read(globalToastProvider.notifier)
                  .showToast('로그인이 필요한 기능이에요');
              showCustomDialog(context, const LoginDialog());
              return;
            }

            if (user.emailVerified == false) {
              ref
                  .read(globalToastProvider.notifier)
                  .showToast('내정보 이메일 인증 후 이용할 수 있어요');
              return;
            }

            ref
                .read(noticeSavedProvider(noticeId).notifier)
                .toggleSave(isSaved: !isSaved, noticeId: noticeId);
          },
        );
      },
      error: (error, stackTrace) {
        return AppIconActiveButton(
          isActive: false,
          icon: AppIcon(AppIcons.bookmark, size: AppIconSize.medium),
          activeIcon: AppIcon(AppIcons.bookmarkCheck, size: AppIconSize.medium),
          onPressed: () {
            ref
                .read(globalToastProvider.notifier)
                .showToast('공고 저장에 실패했어요\n잠시 후 다시 시도해주세요');
          },
        );
      },
      loading: () {
        return AppIconActiveButton(
          isActive: false,
          icon: AppIcon(AppIcons.bookmark, size: AppIconSize.medium),
          activeIcon: AppIcon(AppIcons.bookmarkCheck, size: AppIconSize.medium),
          onPressed: () {
            // loading...
          },
        );
      },
    );
  }
}
