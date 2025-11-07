// 📄 lib/widgets/play/completion_dialog.dart
import 'package:flutter/material.dart';
import 'package:amagama/models/sentence.dart';

/// 🎉 CompletionDialog — shown when the player finishes a sentence.
class CompletionDialog extends StatelessWidget {
  final int sentenceIndex;
  final Sentence? sentence; // 👈 make optional
  final String? sentenceText; // 👈 alternate input
  final VoidCallback onNext;

  const CompletionDialog({
    super.key,
    required this.sentenceIndex,
    this.sentence,
    this.sentenceText,
    required this.onNext,
  });

  String get displayText =>
      sentence?.text ?? sentenceText ?? 'Unknown sentence';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Great job!',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        'You finished:\n"$displayText"',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
