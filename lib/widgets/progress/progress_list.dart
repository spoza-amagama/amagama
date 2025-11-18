// 📄 lib/widgets/progress/progress_list.dart
//
// Simple placeholder progress list. Replace with real implementation later.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:provider/provider.dart';
import 'package:amagama/data/index.dart';

class ProgressList extends StatelessWidget {
  const ProgressList({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return ListView.builder(
      padding: const EdgeInsets.all(AmagamaSpacing.md),
      itemCount: sentences.length,
      itemBuilder: (context, index) {
        final sentence = sentences[index];
        final prog = game.progress.length > index ? game.progress[index] : null;
        final cycles = prog?.cyclesCompleted ?? 0;

        return Card(
          child: ListTile(
            title: Text(sentence.text),
            subtitle: Text('Cycles: $cycles of ${game.cyclesTarget}'),
          ),
        );
      },
    );
  }
}