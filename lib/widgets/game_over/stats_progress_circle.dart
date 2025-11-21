// 📄 lib/widgets/game_over/stats_progress_circle.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class StatsProgressCircle extends StatelessWidget {
  final double value;

  const StatsProgressCircle({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 7,
            backgroundColor:
                AmagamaColors.surface.withValues(alpha: 0.7),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AmagamaColors.secondary,
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: AmagamaTypography.bodyStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: AmagamaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}