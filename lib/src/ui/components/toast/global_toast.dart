import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/toast_service.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class GlobalToast extends ConsumerWidget {
  final Widget child;

  const GlobalToast({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toastState = ref.watch(globalToastProvider);
    final bottomSafeAreaPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        child,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: AppMargin.medium,
          right: AppMargin.medium,
          bottom: toastState.isVisible ? bottomSafeAreaPadding + 40 : -100,
          child: GestureDetector(
            onTap: () => ref.read(globalToastProvider.notifier).hideToast(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: DefaultTextStyle(
                style: AppTextStyle.body1.copyWith(color: Colors.white),
                child: Text(toastState.message, textAlign: TextAlign.start),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
