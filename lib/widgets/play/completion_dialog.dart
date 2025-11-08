// 📄 lib/widgets/play/completion_dialog.dart
// 🏁 CompletionDialog
// ----------------------------------------------------------
// Shows end-of-round actions. Supports "Next" and optional "Repeat".
// If `onRepeat` is null, hides the Repeat button.

import 'package:flutter/material.dart';

class CompletionDialog extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onRepeat;

  const CompletionDialog({
    super.key,
    required this.onNext,
    this.onRepeat, // optional
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Great job!'),
      content: const Text('You matched all the cards.'),
      actions: [
        if (onRepeat != null)
          TextButton(
            onPressed: onRepeat,
            child: const Text('Repeat'),
          ),
        FilledButton(
          onPressed: onNext,
          child: const Text('Next'),
        ),
      ],
    );
  }
}
