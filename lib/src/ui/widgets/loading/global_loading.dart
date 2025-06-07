import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/providers/loading_provider.dart';

class GlobalLoading extends ConsumerWidget {
  final Widget child;

  const GlobalLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(globalLoadingProvider);

    return Stack(
      children: [
        child,
        if (isLoading)
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.5),
            dismissible: false,
          ),
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
