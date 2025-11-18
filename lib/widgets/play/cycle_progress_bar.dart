// 📄 lib/widgets/play/cycle_progress_bar.dart
import 'package:flutter/material.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:provider/provider.dart';

class CycleProgressBar extends StatelessWidget {
  const CycleProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final progress = game.progress[game.currentSentenceIndex];
    final percent = progress.cyclesCompleted / game.cyclesTarget;

    return LinearProgressIndicator(
      value: percent,
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.grey.shade300,
      color: Colors.orangeAccent,
      minHeight: 8,
    );
  }
}