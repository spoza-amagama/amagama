// 📄 lib/widgets/play/sentence_progress_section.dart
//
// Displays the current sentence and progress indicators
// using African-inspired Amagama theme colors and spacing.

iimport 'package:flutter/material.dart';
import '../../theme/index.dart';
import '../../widgets/home/home_app_bar.dart';
import '../../widgets/home/home_content.dart';
import '../../widgets/home/home_background.dart' as bg;

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
          SizedBox(height: AmagamaSpacing.xs),
          Text(
            'Sentence $currentSentence of $totalSentences',
            style: textTheme.bodySmall,
          ),
          Text(
            'Cycle ${cyclesDone + 1} of $cyclesTarget',
            style: textTheme.bodySmall,
          ),
          SizedBox(height: AmagamaSpacing.sm),
          const CycleProgressBar(),
        ],
      ),
    );
  }
}
