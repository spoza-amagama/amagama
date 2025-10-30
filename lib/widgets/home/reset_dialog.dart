import 'package:flutter/material.dart';

class ResetDialog extends StatelessWidget {
  const ResetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset everything?'),
      content: const Text('This will erase all progress, trophies, and locks.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
      ],
    );
  }
}
