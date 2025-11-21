// 📄 lib/widgets/game_over/trophy_mini_tile.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class TrophyMiniTile extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;

  const TrophyMiniTile({
    super.key,
    required this.emoji,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 26)),
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