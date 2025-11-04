// 📄 lib/widgets/play/sentence_unlock_indicator.dart
import 'package:flutter/material.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:provider/provider.dart';

class SentenceUnlockIndicator extends StatelessWidget {
  final int index;
  const SentenceUnlockIndicator({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final isUnlocked = index <= game.currentSentenceIndex;
    final color =
        isUnlocked ? Colors.greenAccent.shade400 : Colors.grey.shade400;

    return Icon(
      isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
      color: color,
    );
  }
}
