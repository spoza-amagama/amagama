// 📄 lib/widgets/home/home_content.dart
//
// 🏡 HomeContent — main Home Screen body.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/utils/sentence_height.dart';

import 'home_header.dart';
import 'home_sentence_header.dart';
import 'home_sentence_stats.dart';
import 'home_sentence_carousel.dart';
import 'home_progress_bar.dart';
import 'home_buttons.dart';
import 'play_button_centered.dart';
import 'grownups_button.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // 🛑 Prevent crash before GameController.init() finishes
    if (!game.sentences.ready ||
        game.progress.all.isEmpty ||
        game.cycles.cyclesTarget == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AmagamaColors.warning,
                strokeWidth: 4,
              ),
              const SizedBox(height: 20),
              Text(
                'Loading Amagama...',
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: 20,
                  color: AmagamaColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final int idx = game.sentences.currentSentence;
    final sentence = game.sentences.byIndex(idx);
    final prog = game.progress.byIndex(idx);
    final cyclesTarget = game.cycles.cyclesTarget;

    final sentenceHeight = SentenceHeight.of(context, sentence.text);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo + trophies summary
          HomeHeader(game: game),

          const SizedBox(height: AmagamaSpacing.md),

          // Sentence header (1 of XX)
          HomeSentenceHeader(
            sentenceNumber: idx + 1,
            totalSentences: game.sentences.total,
            cyclesDone: prog.cyclesCompleted,
            cyclesTarget: cyclesTarget,
          ),

          const SizedBox(height: AmagamaSpacing.xs),

          // Stats row
          HomeSentenceStats(
            cyclesDone: prog.cyclesCompleted,
            cyclesTarget: cyclesTarget,
            sentenceHeight: sentenceHeight,
          ),

          const SizedBox(height: AmagamaSpacing.sm),

          HomeProgressBar(
            cyclesDone: prog.cyclesCompleted,
            cyclesTarget: cyclesTarget,
          ),

          const SizedBox(height: AmagamaSpacing.lg),

          // Sentence carousel
          SizedBox(
            height: sentenceHeight,
            child: const HomeSentenceCarousel(),
          ),

          const SizedBox(height: AmagamaSpacing.lg),

          const PlayButtonCentered(),
          const SizedBox(height: 12),

          const HomeButtons(),
          const SizedBox(height: 12),

          const GrownUpsButton(),

          const SizedBox(height: 14),
        ],
      ),
    );
  }
}