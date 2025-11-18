// 📄 lib/widgets/home/home_sentence_header.dart
//
// 🏡 HomeSentenceHeader
// Displays the main sentence, cycles, and sentence count.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeSentenceHeader extends StatelessWidget {
  final String sentenceText;
  final int cyclesDone;
  final int cyclesTarget;
  final int sentenceNumber;
  final int totalSentences;

  const HomeSentenceHeader({
    super.key,
    required this.sentenceText,
    required this.cyclesDone,
    required this.cyclesTarget,
    required this.sentenceNumber,
    required this.totalSentences,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main sentence
        Text(
          sentenceText,
          textAlign: TextAlign.center,
          style: AmagamaTypography.titleStyle,
        ),

        const SizedBox(height: AmagamaSpacing.sm),

        // Cycles + sentence number
        Column(
          children: [
            Text(
              'Cycles: $cyclesDone of $cyclesTarget',
              style: AmagamaTypography.subtitleStyle,
            ),
            Text(
              'Sentence $sentenceNumber of $totalSentences',
              style: AmagamaTypography.subtitleStyle,
            ),
          ],
        ),
      ],
    );
  }
}