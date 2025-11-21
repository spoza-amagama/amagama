// 📄 lib/widgets/game_over/trophies_row.dart

import 'package:flutter/material.dart';
import 'trophy_mini_tile.dart';

class TrophiesRow extends StatelessWidget {
  final int bronze;
  final int silver;
  final int gold;

  const TrophiesRow({
    super.key,
    required this.bronze,
    required this.silver,
    required this.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TrophyMiniTile(emoji: '🥉', label: 'Bronze', count: bronze),
        TrophyMiniTile(emoji: '🥈', label: 'Silver', count: silver),
        TrophyMiniTile(emoji: '🥇', label: 'Gold', count: gold),
      ],
    );
  }
}