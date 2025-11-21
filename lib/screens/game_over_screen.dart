// 📄 lib/screens/game_over_screen.dart
// 🎉 Amagama — Game Over / Celebration Screen
//
// Updated to match new ProgressService:
// - No countCompleted()
// - No totalCycles()
// - No week references
// --------------------------------------------------------------------

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
    final currentProgress =
        game.progress.bySentenceId(currentSentence.id);

    // NEW: derive totals from progress list
    final completedSentences = game.progress.all
        .where((p) => p.cyclesCompleted >= cyclesTarget)
        .length;

    final totalCycles = game.progress.all
        .fold<int>(0, (sum, p) => sum + p.cyclesCompleted);

    final bronze = game.trophies.bronzeTotal;
    final silver = game.trophies.silverTotal;
    final gold = game.trophies.goldTotal;

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
              subtitle: 'Sentence complete!',
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