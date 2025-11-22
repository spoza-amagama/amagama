// 📄 lib/widgets/home/sections/home_header_section.dart
//
// HomeHeaderSection — wraps HomeHeaderRow and resolves dynamic numbers.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/widgets/home/content/home_header_row.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    final idx = game.sentences.viewSentence; // correct visible index
    final total = game.sentences.total;

    final progress = game.progress.byIndex(idx);
    final cyclesDone = progress.cyclesCompleted;
    final cyclesTarget = game.cycles.cyclesTarget;

    return HomeHeaderRow(
      sentenceNumber: idx + 1,
      totalSentences: total,
      currentCycle: cyclesDone + 1, // optional
      totalCycles: cyclesTarget, // optional
    );
  }
}
