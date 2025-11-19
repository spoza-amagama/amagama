// 📄 lib/screens/game_over_screen.dart
// 🎉 Amagama — Game Over / Celebration Screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/common/screen_header.dart';
import '../widgets/game_over/game_over_header.dart';
import '../widgets/game_over/game_over_stats_card.dart';
import '../widgets/game_over/game_over_actions.dart';

import '../state/game_controller.dart';
import '../theme/index.dart';
import '../data/index.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // ⭐ Sentence + progress state
    final int idx = game.sentences.currentSentence;
    final sentence = sentences[idx];
    final prog = game.progress.bySentenceId(sentence.id);

    // Trophy totals
    final trophies = game.trophies;
    final bronze = trophies.bronzeTotal;
    final silver = trophies.silverTotal;
    final gold = trophies.goldTotal;

    // Global stats
    final int totalSentences = sentences.length;
    final int completedSentences = game.progress.countCompleted(
      cyclesTarget: game.cycles.cyclesTarget,
    );
    final int totalCycles = game.progress.totalCycles();

    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ───────────────────────────────────────────────
            // Screen header
            // ───────────────────────────────────────────────
            ScreenHeader(
              title: "Well done!",
              subtitle: "You've completed this sentence!",
              showLogo: true,
              cyclesDone: prog.cyclesCompleted,
              cyclesTarget: game.cycles.cyclesTarget,
              sentenceNumber: idx + 1,
              totalSentences: totalSentences,
              leadingAction: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: AmagamaSpacing.md),

            // ───────────────────────────────────────────────
            // Celebration header
            // ───────────────────────────────────────────────
            GameOverHeader(
              title: "Great work!",
              subtitle: "You're getting better every round.",
            ),

            const SizedBox(height: AmagamaSpacing.lg),

            // ───────────────────────────────────────────────
            // Stats card
            // ───────────────────────────────────────────────
            GameOverStatsCard(
              totalSentences: totalSentences,
              completedSentences: completedSentences,
              totalCycles: totalCycles,
              bronze: bronze,
              silver: silver,
              gold: gold,
            ),

            const Spacer(),

            // ───────────────────────────────────────────────
            // Actions
            // ───────────────────────────────────────────────
            const GameOverActions(),

            const SizedBox(height: AmagamaSpacing.lg),
          ],
        ),
      ),
    );
  }
}