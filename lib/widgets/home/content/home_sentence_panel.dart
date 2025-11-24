// 📄 lib/widgets/home/home_sentence_panel.dart
// HomeSentencePanel — big green sentence card with cycles summary below.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeSentencePanel extends StatelessWidget {
  final String sentenceText;
  final int cyclesDone;
  final int cyclesTarget;

  const HomeSentencePanel({
    super.key,
    required this.sentenceText,
    required this.cyclesDone,
    required this.cyclesTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Big green card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AmagamaSpacing.lg,
            vertical: AmagamaSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: AmagamaColors.secondary,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Text(
            sentenceText,
            textAlign: TextAlign.center,
            style: AmagamaTypography.titleStyle.copyWith(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: AmagamaSpacing.md),

        Text(
          'Cycles: $cyclesDone / $cyclesTarget',
          style: AmagamaTypography.bodyStyle.copyWith(
            fontSize: 14,
            color: AmagamaColors.textSecondary,
          ),
        ),
      ],
    );
  }
}