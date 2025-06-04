import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/toast_service.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/ui/components/button/app_icon_active_button.dart';
import 'package:imdaesomun/src/ui/pages/notice/notice_page_view_model.dart';

class BookmarkButton extends ConsumerWidget {
  final String noticeId;

  const BookmarkButton({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notice = ref.watch(noticeSavedProvider(noticeId));

    return notice.when(
      data: (isSaved) {
        return AppIconActiveButton(
          isActive: isSaved,
          icon: AppIcon(AppIcons.bookmark, size: AppIconSize.medium),
          activeIcon: AppIcon(AppIcons.bookmarkCheck, size: AppIconSize.medium),
          onPressed:
              () => ref
                  .read(noticeSavedProvider(noticeId).notifier)
                  .toggleBookmark(isSaved: !isSaved, noticeId: noticeId),
        );
      },
      error: (error, stackTrace) {
        return AppIconActiveButton(
          isActive: false,
          icon: AppIcon(AppIcons.bookmark, size: AppIconSize.medium),
          activeIcon: AppIcon(AppIcons.bookmarkCheck, size: AppIconSize.medium),
          onPressed:
              () => ref
                  .read(globalToastProvider.notifier)
                  .showToast('북마크 상태를 가져오지 못했어요'),
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
