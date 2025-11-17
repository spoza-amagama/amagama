// 📄 lib/widgets/game_over/game_over_stats_card.dart
//
// Displays score and badges earned inside a themed card.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class GameOverStatsCard extends StatelessWidget {
  final int score;
  final int badgesEarned;

  const GameOverStatsCard({
    super.key,
    required this.score,
    required this.badgesEarned,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AmagamaTypography.textTheme;

    return Container(
      padding: const EdgeInsets.all(AmagamaSpacing.md),
      decoration: BoxDecoration(
        color: AmagamaColors.background.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AmagamaSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AmagamaColors.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Score: $score',
            style: textTheme.headlineSmall?.copyWith(
              color: AmagamaColors.secondary,
            ),
          ),
          const SizedBox(height: AmagamaSpacing.sm),
          Text(
            'Badges earned: $badgesEarned',
            style: textTheme.bodyLarge?.copyWith(
              color: AmagamaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}