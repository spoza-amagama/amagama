// 📄 lib/widgets/home/home_trophies_row.dart
//
// 🏅 HomeTrophiesRow — row of 3 trophy chips.

import 'package:flutter/material.dart';
import 'trophy_chip.dart';

class HomeTrophiesRow extends StatelessWidget {
  final int bronze;
  final int silver;
  final int gold;

  const HomeTrophiesRow({
    super.key,
    required this.bronze,
    required this.silver,
    required this.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TrophyChip(
          label: 'Bronze',
          count: bronze,
          emoji: '🥉',
        ),
        const SizedBox(width: 8),
        TrophyChip(
          label: 'Silver',
          count: silver,
          emoji: '🥈',
        ),
        const SizedBox(width: 8),
        TrophyChip(
          label: 'Gold',
          count: gold,
          emoji: '🥇',
        ),
      ],
    );
  }
}