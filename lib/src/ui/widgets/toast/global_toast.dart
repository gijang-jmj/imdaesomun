import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/providers/toast_provider.dart';
import 'package:imdaesomun/src/core/theme/app_size.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';

class GlobalToast extends ConsumerWidget {
  final Widget child;

  const GlobalToast({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toastState = ref.watch(globalToastProvider);
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        child,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          left: AppMargin.medium,
          right: AppMargin.medium,
          top: toastState.isVisible ? topSafeAreaPadding : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            opacity: toastState.isVisible ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: () => ref.read(globalToastProvider.notifier).hideToast(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: DefaultTextStyle(
                  style: AppTextStyle.body1.copyWith(color: Colors.white),
                  child: Text(toastState.message, textAlign: TextAlign.start),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
