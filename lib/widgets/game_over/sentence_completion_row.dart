// 📄 lib/widgets/game_over/sentence_completion_row.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'stats_progress_circle.dart';

class SentenceCompletionRow extends StatelessWidget {
  final int completed;
  final int total;
  final double completion;

  const SentenceCompletionRow({
    super.key,
    required this.completed,
    required this.total,
    required this.completion,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left summary column
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
                '$completed of $total',
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: 18,
                  color: AmagamaColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),
        StatsProgressCircle(value: completion),
      ],
    );
  }
}