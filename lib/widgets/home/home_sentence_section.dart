// 📄 lib/widgets/home/home_sentence_section.dart
//
// HomeSentenceSection — sentence info + carousel for the Home screen.

import 'package:flutter/material.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/utils/sentence_height.dart';

import 'sentences/home_sentence_header.dart';
import 'sentences/home_sentence_carousel.dart';

class HomeSentenceSection extends StatelessWidget {
  final int sentenceNumber;
  final int totalSentences;
  final String sentenceText;

  const HomeSentenceSection({
    super.key,
    required this.sentenceNumber,
    required this.totalSentences,
    required this.sentenceText,
  });

  @override
  Widget build(BuildContext context) {
    final sentenceHeight = SentenceHeight.of(context, sentenceText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSentenceHeader(
          sentenceNumber: sentenceNumber,
          totalSentences: totalSentences,
        ),
        const const SizedBox(height: AmagamaSpacing.md),
        SizedBox(
          height: sentenceHeight,
          child: const HomeSentenceCarousel(),
        ),
      ],
    );
  }
}