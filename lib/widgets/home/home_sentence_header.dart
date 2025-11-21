// 📄 lib/widgets/home/home_sentence_header.dart
//
// 📝 HomeSentenceHeader — shows sentence number only (week-free)

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
    return Row(
      children: [
        Text(
          'Sentence $sentenceNumber of $totalSentences',
          style: AmagamaTypography.titleStyle.copyWith(
            fontSize: 20,
            color: AmagamaColors.textPrimary,
          ),
        ),
      ],
    );
  }
}