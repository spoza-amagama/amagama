// 📄 home_sentence_section.dart
//
// Sentence header + carousel wrapper

import 'package:flutter/material.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/utils/sentence_height.dart';
import 'package:amagama/theme/index.dart';

import '../sentences/home_sentence_header.dart';
import '../sentences/home_sentence_carousel.dart';

class HomeSentenceSection extends StatelessWidget {
  final GameController game;

  const HomeSentenceSection({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final int idx = game.sentences.currentSentence;
    final sentence = game.sentences.byIndex(idx);

    final height = SentenceHeight.of(context, sentence.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSentenceHeader(
          sentenceNumber: idx + 1,
          totalSentences: game.sentences.total,
        ),
        const const SizedBox(height: AmagamaSpacing.md),
        SizedBox(
          height: height,
          child: const HomeSentenceCarousel(),
        ),
      ],
    );
  }
}