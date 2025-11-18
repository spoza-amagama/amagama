// 📄 lib/widgets/home/home_content.dart
//
// 🏡 HomeContent — main Home Screen body.
// • Compressed vertical layout for small screens
// • Uses refactored widgets (stats, trophies, progress, buttons)
// • Smooth carousel height animation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/utils/sentence_height.dart';

import 'home_sentence_carousel.dart';
import 'home_sentence_stats.dart';
import 'home_trophies_row.dart';
import 'home_progress_bar.dart';
import 'play_button_centered.dart';
import 'grownups_button.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // 👁 Live carousel index
    final int viewIdx = game.viewSentenceIndex;
    final sentence = sentences[viewIdx];

    // 🎮 Active sentence progress
    final int activeIdx = game.currentSentenceIndex;
    final cyclesDone = game.progress[activeIdx].cyclesCompleted;
    final cyclesTarget = game.cyclesTarget;

    // 🏆 Global totals
    final bronze = game.totalBronze;
    final silver = game.totalSilver;
    final gold = game.totalGold;

    // 🎛 Dynamic sentence card height
    final lineCount = estimateSentenceLines(sentence.text);
    final double targetHeight = computeSentenceCardHeight(lineCount);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ⬆️ Smaller gap
        const SizedBox(height: AmagamaSpacing.sm),

        // ------------------------------------------------------------
        // 🎠 Sentence Carousel — animated height
        // ------------------------------------------------------------
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(end: targetHeight),
          builder: (_, h, child) => SizedBox(height: h, child: child),
          child: const HomeSentenceCarousel(),
        ),

        const SizedBox(height: 18), // 🔽 tighter

        // ------------------------------------------------------------
        // 📘 Sentence X / Y + Cycles
        // ------------------------------------------------------------
        HomeSentenceStats(
          viewIndex: viewIdx,
          cyclesDone: cyclesDone,
          cyclesTarget: cyclesTarget,
        ),

        const SizedBox(height: 12), // 🔽 tighter

        // ------------------------------------------------------------
        // 🏆 Trophy Row — smaller circles & reduced spacing
        // ------------------------------------------------------------
        HomeTrophiesRow(
          bronze: bronze,
          silver: silver,
          gold: gold,
        ),

        const SizedBox(height: 12), // 🔽 tighter spacing

        // ------------------------------------------------------------
        // 📊 Progress Bar
        // ------------------------------------------------------------
        HomeProgressBar(
          progress: cyclesDone,
          target: cyclesTarget,
        ),

        const SizedBox(height: 26), // 🔽 previously xl

        // ------------------------------------------------------------
        // ▶ Play Button (perfectly centered label)
        // ------------------------------------------------------------
        const PlayButtonCentered(),

        const SizedBox(height: 14),

        // ------------------------------------------------------------
        // 🔒 Grown Ups Button
        // ------------------------------------------------------------
        const GrownUpsButton(),

        const SizedBox(height: 18), // 🔽 tighter to bottom
      ],
    );
  }
}