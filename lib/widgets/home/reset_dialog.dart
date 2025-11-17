// 📄 lib/widgets/home/reset_dialog.dart

import 'package:flutter/material.dart';

class ResetDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ResetDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Reset Progress"),
      content: const Text("Are you sure you want to reset all progress?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text("Reset"),
        ),
      ],
    );
  }
}