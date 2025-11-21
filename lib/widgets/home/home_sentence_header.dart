// 📄 lib/widgets/home/home_sentence_header.dart
//
// 📝 HomeSentenceHeader — sentence number + cycles info.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeSentenceHeader extends StatelessWidget {
  final int sentenceNumber;
  final int totalSentences;
  final int cyclesDone;
  final int cyclesTarget;

  const HomeSentenceHeader({
    super.key,
    required this.sentenceNumber,
    required this.totalSentences,
    required this.cyclesDone,
    required this.cyclesTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Sentence $sentenceNumber of $totalSentences',
          style: AmagamaTypography.titleStyle.copyWith(
            fontSize: 20,
            color: AmagamaColors.textPrimary,
          ),
        ),
        const Spacer(),
        Text(
          'Cycles: $cyclesDone / $cyclesTarget',
          style: AmagamaTypography.bodyStyle.copyWith(
            color: AmagamaColors.textSecondary,
          ),
        ),
      ],
    );
  }
}