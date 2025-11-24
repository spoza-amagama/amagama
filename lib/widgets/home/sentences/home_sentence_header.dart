// 📄 lib/widgets/home/sentences/home_sentence_header.dart
//
// HomeSentenceHeader — shows "Sentence X of Y".
// ------------------------------------------------------------
// • Centered text below trophies/progress
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class HomeSentenceHeader extends StatelessWidget {
  final int sentenceNumber;
  final int totalSentences;

  const HomeSentenceHeader({
    super.key,
    required this.sentenceNumber,
    required this.totalSentences,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sentence $sentenceNumber of $totalSentences',
      textAlign: TextAlign.center,
      style: AmagamaTypography.titleStyle.copyWith(
        fontSize: 20,
        color: AmagamaColors.textPrimary,
      ),
    );
  }
}