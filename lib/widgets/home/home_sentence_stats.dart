// 📄 lib/widgets/home/home_sentence_stats.dart
//
// 📊 HomeSentenceStats — compact info row for current sentence.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeSentenceStats extends StatelessWidget {
  final int cyclesDone;
  final int cyclesTarget;
  final double sentenceHeight; // still used for layout

  const HomeSentenceStats({
    super.key,
    required this.cyclesDone,
    required this.cyclesTarget,
    required this.sentenceHeight,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (cyclesTarget - cyclesDone).clamp(0, cyclesTarget);

    return Row(
      children: [
        Icon(
          Icons.school_rounded,
          size: 20,
          color: AmagamaColors.textSecondary.withValues(alpha: 0.9),
        ),
        const SizedBox(width: 6),
        Text(
          '$cyclesDone cycles done • $remaining to go',
          style: AmagamaTypography.bodyStyle.copyWith(
            color: AmagamaColors.textSecondary,
          ),
        ),
      ],
    );
  }
}