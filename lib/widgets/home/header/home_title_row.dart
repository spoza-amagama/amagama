// 📄 lib/widgets/home/home_title_row.dart
//
// HomeTitleRow — game title + sentence indicator + cycle indicator.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeTitleRow extends StatelessWidget {
  final int sentenceNumber;   // 1-based
  final int totalSentences;
  final int currentCycle;     // 1-based
  final int totalCycles;

  const HomeTitleRow({
    super.key,
    required this.sentenceNumber,
    required this.totalSentences,
    required this.currentCycle,
    required this.totalCycles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------
        // TITLE
        // --------------------------
        Text(
          'Amagama',
          style: AmagamaTypography.titleStyle.copyWith(
            fontSize: 28,
            color: AmagamaColors.textPrimary,
          ),
        ),

        const SizedBox(height: 4),

        // --------------------------
        // SENTENCE X / Y
        // --------------------------
        Text(
          'Sentence $sentenceNumber / $totalSentences',
          style: AmagamaTypography.bodyStyle.copyWith(
            color: AmagamaColors.textSecondary,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 2),

        // --------------------------
        // CYCLE A / B
        // --------------------------
        Text(
          'Cycle $currentCycle / $totalCycles',
          style: AmagamaTypography.bodyStyle.copyWith(
            color: AmagamaColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}