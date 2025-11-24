// 📄 lib/widgets/home/content/home_trophies_row.dart
// HomeTrophiesRow — shows Bronze / Silver / Gold cup icons + labels + counts.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';

class HomeTrophiesRow extends StatelessWidget {
  const HomeTrophiesRow({super.key});

  @override
  Widget build(BuildContext context) {
    final trophies = context.watch<GameController>().trophies;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _TrophyColumn(
          label: "Bronze",
          count: trophies.bronzeTotal,
          color: const Color(0xFFCD7F32), // Bronze
        ),
        _TrophyColumn(
          label: "Silver",
          count: trophies.silverTotal,
          color: const Color(0xFFC0C0C0), // Silver
        ),
        _TrophyColumn(
          label: "Gold",
          count: trophies.goldTotal,
          color: const Color(0xFFFFD700), // Gold
        ),
      ],
    );
  }
}

class _TrophyColumn extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _TrophyColumn({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.emoji_events,
          size: 34,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AmagamaTypography.bodyStyle.copyWith(
            fontSize: 14,
            color: AmagamaColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "$count",
          style: AmagamaTypography.bodyStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AmagamaColors.textPrimary,
          ),
        ),
      ],
    );
  }
}