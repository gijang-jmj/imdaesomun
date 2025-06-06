import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/toast_service.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/ui/widgets/app_bar/app_app_bar.dart';
import 'package:imdaesomun/src/ui/components/button/app_text_button.dart';
import 'package:imdaesomun/src/ui/pages/notice/notice_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/notice/widgets/notice_save_button.dart';
import 'package:imdaesomun/src/ui/pages/notice/widgets/notice_detail_card.dart';

class NoticePage extends ConsumerWidget {
  final String id;

  const NoticePage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppAppBar(title: const Text('공고 상세')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppMargin.medium,
                    vertical: AppMargin.small,
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final notice = ref.watch(noticeDetailProvider(id));
                      return notice.when(
                        data: (data) {
                          return NoticeDetailCard(notice: data);
                        },
                        error: (error, stackTrace) {
                          return Center(child: Text('Error: $error'));
                        },
                        loading: () => const NoticeDetailCardSkeleton(),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: AppEdgeInsets.bottomButtonMargin,
              child: Row(
                spacing: AppMargin.small,
                children: [
                  Expanded(
                    flex: 8,
                    child: AppTextButton(
                      onPressed:
                          () => ref
                              .read(noticeDetailProvider(id).notifier)
                              .openLink(
                                onError: (error) {
                                  ref
                                      .read(globalToastProvider.notifier)
                                      .showToast(error);
                                },
                              ),
                      suffixIcon: AppIcon(
                        AppIcons.link,
                        size: AppIconSize.medium,
                      ),
                      text: '공고 열기',
                    ),
                  ),
                  Expanded(flex: 2, child: NoticeSaveButton(noticeId: id)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
