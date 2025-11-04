// 📂 lib/widgets/play/completion_dialog.dart
import 'package:flutter/material.dart';
import 'package:amagama/models/sentence.dart';

/// 🎉 CompletionDialog
/// Shown when the player finishes matching a full sentence.
class CompletionDialog extends StatelessWidget {
  final int sentenceIndex;
  final Sentence sentence;
  final VoidCallback onNext;

  const CompletionDialog({
    super.key,
    required this.sentenceIndex,
    required this.sentence,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final msg = "You’ve completed Sentence ${sentenceIndex + 1}!";

    return AlertDialog(
      backgroundColor: const Color(0xFFFFECB3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Center(
        child: Text(
          "🎉 Great job!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sentence.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text("Next"),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
