// 📄 lib/screens/game_over_screen.dart
// 🎉 Amagama — Game Over / Celebration Screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/common/index.dart';
import '../widgets/game_over/game_over_header.dart';
import '../widgets/game_over/game_over_stats_card.dart';
import '../widgets/game_over/game_over_actions.dart';
import '../state/game_controller.dart';
import '../theme/index.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    final currentIdx = game.sentences.currentSentence;
    final totalSentences = game.sentences.total;
    final cyclesTarget = game.cycles.cyclesTarget;

    final currentSentence = game.sentences.byIndex(currentIdx);

    // FIX: ID must be int, not String
    final currentProgress = game.progress.bySentenceId(currentSentence.id);

    final completedSentences = game.progress.countCompleted(cyclesTarget);
    final totalCycles = game.progress.totalCycles();

    final bronze = game.trophies.bronze;
    final silver = game.trophies.silver;
    final gold = game.trophies.gold;

    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Well done!',
              subtitle: "You've completed this sentence!",
              showLogo: true,
              cyclesDone: currentProgress.cyclesCompleted,
              cyclesTarget: cyclesTarget,
              sentenceNumber: currentIdx + 1,
              totalSentences: totalSentences,
              leadingAction: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: AmagamaSpacing.lg),

            const GameOverHeader(
              title: 'Great Job!',
              subtitle: 'You finished the week!',
            ),

            const SizedBox(height: AmagamaSpacing.md),

            GameOverStatsCard(
              totalSentences: totalSentences,
              completedSentences: completedSentences,
              totalCycles: totalCycles,
              bronze: bronze,
              silver: silver,
              gold: gold,
            ),

            const Spacer(),
            const GameOverActions(),
            const SizedBox(height: AmagamaSpacing.lg),
          ],
        ),
      ),
    );
  }
}