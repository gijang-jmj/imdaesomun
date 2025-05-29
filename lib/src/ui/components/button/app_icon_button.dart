import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final EdgeInsetsGeometry padding;
  final Size minimumSize;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.padding = EdgeInsets.zero,
    this.minimumSize = Size.zero,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStateProperty.all<EdgeInsets>(padding as EdgeInsets),
        minimumSize: WidgetStateProperty.all<Size>(minimumSize),
      ),
    );
  }
}
