// 📄 lib/widgets/game_over/cycles_played_row.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class CyclesPlayedRow extends StatelessWidget {
  final int totalCycles;

  const CyclesPlayedRow({super.key, required this.totalCycles});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}