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

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 🧩 Header with progress + sentence info
            Builder(
              builder: (context) {
                final game = context.watch<GameController>();
                final currentIdx = game.currentSentenceIndex;
                final cyclesDone = game.currentProg.cyclesCompleted;
                final cyclesTarget = game.cyclesTarget;
                final totalSentences = game.progress.length;

                return ScreenHeader(
                  title: 'Well Done!',
                  subtitle: "You've completed the sentence!",
                  showLogo: true,
                  cyclesDone: cyclesDone,
                  cyclesTarget: cyclesTarget,
                  sentenceNumber: currentIdx + 1,
                  totalSentences: totalSentences,
                  leadingAction: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                );
              },
            ),

            const GameOverHeader(),
            const SizedBox(height: AmagamaSpacing.md),

            // 🎯 Stats (score + badges)
            Builder(
              builder: (context) {
                final game = context.watch<GameController>();
                final score = game.progress.fold<int>(
                  0,
                  (sum, p) => sum + p.cyclesCompleted,
                );
                final badgesEarned = game.progress.where(
                  (p) => p.cyclesCompleted >= game.cyclesTarget,
                ).length;

                return GameOverStatsCard(
                  score: score,
                  badgesEarned: badgesEarned,
                );
              },
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