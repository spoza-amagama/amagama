// 📄 lib/widgets/game_over/game_over_stats_card.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'sentence_completion_row.dart';
import 'cycles_played_row.dart';
import 'trophies_row.dart';

class GameOverStatsCard extends StatelessWidget {
  final int totalSentences;
  final int completedSentences;
  final int totalCycles;
  final int bronze;
  final int silver;
  final int gold;

  const GameOverStatsCard({
    super.key,
    required this.totalSentences,
    required this.completedSentences,
    required this.totalCycles,
    required this.bronze,
    required this.silver,
    required this.gold,
  });

  @override
  Widget build(BuildContext context) {
    final completion = totalSentences == 0
        ? 0.0
        : (completedSentences / totalSentences).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AmagamaColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SentenceCompletionRow(
            completed: completedSentences,
            total: totalSentences,
            completion: completion,
          ),

          const SizedBox(height: 16),
          const Divider(height: 24),

          CyclesPlayedRow(totalCycles: totalCycles),

          const SizedBox(height: 16),

          TrophiesRow(
            bronze: bronze,
            silver: silver,
            gold: gold,
          ),
        ],
      ),
    );
  }
}