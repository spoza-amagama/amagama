// 📄 lib/widgets/home/content/home_header_row.dart
//
// HomeHeaderRow — logo + Amagama + sentence and cycle counters.
// ------------------------------------------------------------
// • Shows "Sentence X / Y"
// • Optionally shows "Cycle A / B" on the next line
// • Used at top of the Home screen header section
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeHeaderRow extends StatelessWidget {
  final int sentenceNumber;
  final int totalSentences;

  /// Optional: current cycle (e.g. 2 of 6). If null, cycle row is hidden.
  final int? currentCycle;

  /// Optional: total cycles target. If null, cycle row is hidden.
  final int? totalCycles;

  const HomeHeaderRow({
    super.key,
    required this.sentenceNumber,
    required this.totalSentences,
    this.currentCycle,
    this.totalCycles,
  });

  bool get _showCycles =>
      currentCycle != null && totalCycles != null && totalCycles! > 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side — Amagama title
        Text(
          'Amagama',
          style: AmagamaTypography.titleStyle.copyWith(
            fontSize: 28,
            color: AmagamaColors.textPrimary,
          ),
        ),

        const Spacer(),

        // Right side — sentence + optional cycle info
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sentence $sentenceNumber / $totalSentences',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary,
              ),
            ),
            if (_showCycles)
              Text(
                'Cycle $currentCycle / $totalCycles',
                style: AmagamaTypography.bodyStyle.copyWith(
                  color: AmagamaColors.textSecondary,
                  fontSize: 13,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
