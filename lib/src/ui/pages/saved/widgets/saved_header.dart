import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:imdaesomun/src/ui/pages/saved/widgets/saved_filter_button.dart';

class SavedHeader extends ConsumerWidget {
  final VoidCallback scrollToTop;

  const SavedHeader({super.key, required this.scrollToTop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedNotices = ref.watch(savedNoticesProvider).value;
    final groupValue = ref.watch(savedFilterProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppMargin.medium),
      child: Row(
        spacing: AppMargin.small,
        children: [
          SavedFilterButton(
            groupValue: groupValue,
            value: 'all',
            text: '전체 ${savedNotices?.totalCount ?? 0}',
            onPressed: () {
              if (savedNotices == null || groupValue == 'all') return;
              scrollToTop();
              ref.read(savedFilterProvider.notifier).state = 'all';
              ref.read(savedNoticesProvider.notifier).refreshSavedNotices();
            },
          ),
          SavedFilterButton(
            groupValue: groupValue,
            value: 'sh',
            text: 'SH ${savedNotices?.shCount ?? 0}',
            onPressed: () {
              if (savedNotices == null || groupValue == 'sh') return;
              scrollToTop();
              ref.read(savedFilterProvider.notifier).state = 'sh';
              ref
                  .read(savedNoticesProvider.notifier)
                  .refreshSavedNotices(filter: 'sh');
            },
          ),
          SavedFilterButton(
            groupValue: groupValue,
            value: 'gh',
            text: 'GH ${savedNotices?.ghCount ?? 0}',
            onPressed: () {
              if (savedNotices == null || groupValue == 'gh') return;
              scrollToTop();
              ref.read(savedFilterProvider.notifier).state = 'gh';
              ref
                  .read(savedNoticesProvider.notifier)
                  .refreshSavedNotices(filter: 'gh');
            },
          ),
        ],
      ),
    );
  }
}
