import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_style.dart';
import 'package:imdaesomun/src/ui/pages/notice/notice_page_view_model.dart';
import 'package:imdaesomun/src/ui/widgets/card/notice_detail_card.dart';

class NoticePage extends ConsumerWidget {
  final String id;

  const NoticePage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notice = ref.watch(noticePageViewModelProvider(id));

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(title: const Text('공고 상세')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppMargin.medium,
              vertical: AppMargin.small,
            ),
            child: notice.when(
              data: (data) {
                return NoticeDetailCard(notice: data);
              },
              error: (error, stackTrace) {
                return Center(child: Text('Error: $error'));
              },
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
