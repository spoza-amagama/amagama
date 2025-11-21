// 📄 lib/widgets/home/trophy_chip.dart
//
// 🏅 TrophyChip — compact emoji + count indicator used on Home Screen.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class TrophyChip extends StatelessWidget {
  final String label;   // Bronze / Silver / Gold
  final int count;      // Number earned
  final String emoji;   // 🥉 🥈 🥇

  const TrophyChip({
    super.key,
    required this.label,
    required this.count,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final earned = count > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AmagamaColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: earned ? AmagamaColors.textPrimary : Colors.grey.shade400,
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: AmagamaTypography.bodyStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: earned
                  ? AmagamaColors.textPrimary
                  : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}