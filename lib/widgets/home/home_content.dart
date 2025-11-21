// 📄 lib/widgets/home/home_content.dart
//
// 🏡 HomeContent — week-free simplified Home screen body.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/utils/sentence_height.dart';

import 'home_header.dart';
import 'home_sentence_header.dart';
import 'home_sentence_carousel.dart';
import 'play_button_centered.dart';
import 'grownups_button.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // Simple, safe loading guard.
    if (!game.sentences.ready) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: AmagamaColors.warning,
        ),
      );
    }

    final int idx = game.sentences.currentSentence;
    final sentence = game.sentences.byIndex(idx);

    final sentenceHeight = SentenceHeight.of(context, sentence.text);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo + trophy summary
          HomeHeader(game: game),

          const SizedBox(height: AmagamaSpacing.lg),

          // Sentence header: “Sentence 4 of 20”
          HomeSentenceHeader(
            sentenceNumber: idx + 1,
            totalSentences: game.sentences.total,
          ),

          const SizedBox(height: AmagamaSpacing.md),

          // Sentence preview (carousel handles view-only interaction)
          SizedBox(
            height: sentenceHeight,
            child: const HomeSentenceCarousel(),
          ),

          const SizedBox(height: AmagamaSpacing.xl),

          const PlayButtonCentered(),

          const SizedBox(height: 12),

          const GrownUpsButton(),

          const SizedBox(height: AmagamaSpacing.lg),
        ],
      ),
    );
  }
}