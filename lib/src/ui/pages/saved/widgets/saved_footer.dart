import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';
import 'package:imdaesomun/src/core/theme/app_icon.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/ui/pages/saved/saved_page_view_model.dart';
import 'package:imdaesomun/src/ui/widgets/footer/copyright_footer.dart';

class SavedFooter extends ConsumerWidget {
  const SavedFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedNotices = ref.watch(savedNoticesProvider).value;

    return Column(
      children: [
        savedNotices != null && savedNotices.notices.isNotEmpty
            ? const Spacer()
            : Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppMargin.extraLarge),
                  child: AppIcon(
                    AppIcons.homeFill,
                    size: 100,
                    color: AppColors.gray500WithOpacity10,
                  ),
                ),
              ),
            ),
        const SizedBox(height: AppMargin.extraLarge),
        const CopyrightFooter(),
      ],
    );
  }
}
