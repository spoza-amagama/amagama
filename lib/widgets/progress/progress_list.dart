// 📄 lib/widgets/progress/progress_list.dart
//
// Simple progress list using GameController services.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/theme/index.dart';
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

        // FIX: ID must be int, not String
        final prog = game.progress.bySentenceId(sentence.id);

        final cycles = prog.cyclesCompleted;
        final target = game.cycles.cyclesTarget;

        return Card(
          child: ListTile(
            title: Text(sentence.text),
            subtitle: Text('Cycles: $cycles of $target'),
          ),
        );
      },
    );
  }
}