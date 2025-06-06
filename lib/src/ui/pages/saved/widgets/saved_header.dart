import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/saved/widgets/saved_filter_button.dart';
import 'package:shimmer/shimmer.dart';

class SavedHeader extends ConsumerWidget {
  const SavedHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedNotices = ref.watch(savedNoticesProvider);
    final groupValue = ref.watch(savedFilterProvider);

    return savedNotices.when(
      loading: () => _savedHeaderSkeleton(),
      error: (e, st) => Center(child: Text('오류: $e')),
      data: (page) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppMargin.medium),
          child: Row(
            spacing: AppMargin.small,
            children: [
              SavedFilterButton(
                groupValue: groupValue,
                value: 'all',
                text: '전체 ${page.totalCount}',
                onPressed: () {
                  if (groupValue == 'all') return;
                  ref.read(savedFilterProvider.notifier).state = 'all';
                  ref.read(savedNoticesProvider.notifier).refreshSavedNotices();
                },
              ),
              SavedFilterButton(
                groupValue: groupValue,
                value: 'sh',
                text: 'SH ${page.shCount}',
                onPressed: () {
                  if (groupValue == 'sh') return;
                  ref.read(savedFilterProvider.notifier).state = 'sh';
                  ref
                      .read(savedNoticesProvider.notifier)
                      .refreshSavedNotices(filter: 'sh');
                },
              ),
              SavedFilterButton(
                groupValue: groupValue,
                value: 'gh',
                text: 'GH ${page.ghCount}',
                onPressed: () {
                  if (groupValue == 'gh') return;
                  ref.read(savedFilterProvider.notifier).state = 'gh';
                  ref
                      .read(savedNoticesProvider.notifier)
                      .refreshSavedNotices(filter: 'gh');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _savedHeaderSkeleton() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppMargin.medium),
    child: Row(
      spacing: AppMargin.small,
      children: List.generate(
        3,
        (index) => Shimmer.fromColors(
          baseColor: AppColors.gray100,
          highlightColor: AppColors.gray200,
          child: Container(
            width: 60,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
          ),
        ),
      ),
    ),
  );
}
