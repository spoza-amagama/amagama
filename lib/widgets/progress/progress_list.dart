// 📄 lib/widgets/progress/progress_list.dart
//
// 📊 ProgressList — shows progress for each sentence.
// Compatible with new GameController service API.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
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

        // New ProgressService API
        final prog = game.progress.bySentenceId(sentence.id);
        final cyclesDone = prog.cyclesCompleted;

        final target = game.cycles.cyclesTarget;

        return Card(
          color: AmagamaColors.surface,
          child: ListTile(
            title: Text(
              sentence.text,
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Cycles: $cyclesDone of $target',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }
}