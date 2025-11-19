// 📄 lib/widgets/home/home_trophies.dart
//
// 🏆 HomeTrophies — three trophy chips + subtle per-sentence bar.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/theme/index.dart';

import 'home_trophies_row.dart';

class HomeTrophies extends StatelessWidget {
  const HomeTrophies({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    final idx = game.sentences.currentSentence;
    if (game.progress.all.isEmpty || idx >= game.progress.all.length) {
      return const SizedBox.shrink();
    }

    final prog = game.progress.byIndex(idx);
    final cyclesTarget = game.cycles.cyclesTarget;
    final fraction = cyclesTarget == 0
        ? 0.0
        : (prog.cyclesCompleted / cyclesTarget).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeTrophiesRow(
          bronze: game.trophies.bronze,
          silver: game.trophies.silver,
          gold: game.trophies.gold,
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor:
                AmagamaColors.surface.withValues(alpha: 0.6),
            color: AmagamaColors.warning,
          ),
        ),
      ],
    );
  }
}