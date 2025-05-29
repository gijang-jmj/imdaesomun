import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: const Text('An error occurred. Please try again later.'),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('OK')),
      ],
    );
  }
}
