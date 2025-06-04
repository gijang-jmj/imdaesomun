import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DialogPage extends ConsumerWidget {
  const DialogPage({super.key, required this.dialog});

  final Widget dialog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Dim layer
        Positioned.fill(
          child: GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
        ),
        // Dialog widget
        Center(child: dialog),
      ],
    );
  }
}
