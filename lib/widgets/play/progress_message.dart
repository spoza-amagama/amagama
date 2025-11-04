// 📄 lib/widgets/play/progress_message.dart
import 'package:flutter/material.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:provider/provider.dart';

class ProgressMessage extends StatelessWidget {
  const ProgressMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final total = game.progress.length;
    final current = game.currentSentenceIndex + 1;
    final percent = ((current / total) * 100).round();

    return Text(
      "You’ve mastered $current of $total sentences ($percent%)!",
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }
}
