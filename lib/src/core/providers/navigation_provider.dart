import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final navigationShellProvider = StateProvider<StatefulNavigationShell?>(
  (ref) => null,
);

class NavigationShellProvider extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final Widget child;

  const NavigationShellProvider({
    super.key,
    required this.navigationShell,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navigationShellProvider.notifier).state = navigationShell;
    });

    return child;
  }
}
