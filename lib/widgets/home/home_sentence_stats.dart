// 📄 lib/widgets/home/home_sentence_stats.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/data/index.dart';

class HomeSentenceStats extends StatelessWidget {
  final int viewIndex;
  final int cyclesDone;
  final int cyclesTarget;

  const HomeSentenceStats({
    super.key,
    required this.viewIndex,
    required this.cyclesDone,
    required this.cyclesTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sentence ${viewIndex + 1} of ${sentences.length}",
          style: AmagamaTypography.progressStyle,
        ),
        const SizedBox(height: AmagamaSpacing.xs),
        Text(
          "Cycles: $cyclesDone / $cyclesTarget",
          style: AmagamaTypography.progressStyle,
        ),
      ],
    );
  }
}