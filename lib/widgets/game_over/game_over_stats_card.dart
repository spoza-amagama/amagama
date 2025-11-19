// 📄 lib/widgets/game_over/game_over_stats_card.dart
//
// 📊 GameOverStatsCard — compact summary of session / overall stats.
// Data-only: caller (screen) provides all numbers.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class GameOverStatsCard extends StatelessWidget {
  /// Total number of sentences in the game.
  final int totalSentences;

  /// How many sentences are fully completed.
  final int completedSentences;

  /// Total cycles completed across all sentences (or this session).
  final int totalCycles;

  /// Trophy counts (global).
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
          // Progress row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sentences completed',
                      style: AmagamaTypography.bodyStyle.copyWith(
                        color: AmagamaColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$completedSentences of $totalSentences',
                      style: AmagamaTypography.titleStyle.copyWith(
                        fontSize: 18,
                        color: AmagamaColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: completion,
                      strokeWidth: 7,
                      backgroundColor:
                          AmagamaColors.surface.withValues(alpha: 0.7),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AmagamaColors.secondary,
                      ),
                    ),
                    Text(
                      '${(completion * 100).round()}%',
                      style: AmagamaTypography.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AmagamaColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 24),

          // Cycles
          Row(
            children: [
              Icon(
                Icons.loop_rounded,
                size: 22,
                color: AmagamaColors.textSecondary.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 8),
              Text(
                'Cycles played: $totalCycles',
                style: AmagamaTypography.bodyStyle.copyWith(
                  color: AmagamaColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Trophies row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TrophyMiniTile(
                emoji: '🥉',
                label: 'Bronze',
                count: bronze,
              ),
              _TrophyMiniTile(
                emoji: '🥈',
                label: 'Silver',
                count: silver,
              ),
              _TrophyMiniTile(
                emoji: '🥇',
                label: 'Gold',
                count: gold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrophyMiniTile extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;

  const _TrophyMiniTile({
    required this.emoji,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 26),
        ),
        const SizedBox(height: 4),
        Text(
          '$count × $label',
          style: AmagamaTypography.bodyStyle.copyWith(
            fontSize: 13,
            color: AmagamaColors.textSecondary,
          ),
        ),
      ],
    );
  }
}