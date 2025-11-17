// 📄 lib/widgets/play/sentence_progress_section.dart
//
// Displays current sentence and cycle progress using Amagama theme.

import 'package:flutter/material.dart';
import '../../../theme/index.dart';
import '../../../widgets/play/cycle_progress_bar.dart';

class SentenceProgressSection extends StatelessWidget {
  final String sentenceText;
  final int currentSentence;
  final int totalSentences;
  final int cyclesDone;
  final int cyclesTarget;

  const SentenceProgressSection({
    super.key,
    required this.sentenceText,
    required this.currentSentence,
    required this.totalSentences,
    required this.cyclesDone,
    required this.cyclesTarget,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AmagamaTypography.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            sentenceText,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: AmagamaSpacing.xs),
          Text('Sentence $currentSentence of $totalSentences',
              style: textTheme.bodySmall),
          Text('Cycle ${cyclesDone + 1} of $cyclesTarget',
              style: textTheme.bodySmall),
          const SizedBox(height: AmagamaSpacing.sm),
          const CycleProgressBar(),
        ],
      ),
    );
  }
}