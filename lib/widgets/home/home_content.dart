// 📄 lib/widgets/home/home_content.dart
//
// 🏡 HomeContent — main Home Screen body (visible progress bar + compact layout)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/utils/sentence_height.dart';

// Local widgets
import 'home_sentence_carousel.dart';
import 'home_sentence_stats.dart';
import 'home_trophies_row.dart';
import 'play_button_centered.dart';
import 'grownups_button.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // ---------------------------------------------------------------------------
    // 🛑 SAFE LOAD — avoid RangeError before GameController.init()
    // ---------------------------------------------------------------------------
    if (game.progress.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFFEAB308),
                strokeWidth: 4,
              ),
              const SizedBox(height: 20),
              Text(
                "Loading Amagama...",
                style: AmagamaTypography.titleStyle.copyWith(
                  fontSize: 20,
                  color: AmagamaColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "Preparing your sentence deck",
                style: AmagamaTypography.bodyStyle.copyWith(
                  color: AmagamaColors.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // ✅ Normal render (data loaded)
    // ---------------------------------------------------------------------------

    // Live sentence index + text
    final int viewIdx = game.viewSentenceIndex;
    final sentence = sentences[viewIdx];

    // Active progress
    final int activeIdx = game.currentSentenceIndex;
    final int cyclesDone = game.progress[activeIdx].cyclesCompleted;
    final int cyclesTarget = game.cyclesTarget;

    // Global trophies
    final int bronze = game.totalBronze;
    final int silver = game.totalSilver;
    final int gold = game.totalGold;

    // Sentence card height
    final int lineCount = estimateSentenceLines(sentence.text);
    final double targetHeight = computeSentenceCardHeight(lineCount);

    // Fraction for bar fill
    final double fraction = cyclesTarget == 0
        ? 0
        : (cyclesDone / cyclesTarget).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 6),

        // 🎠 Carousel with animated height
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(end: targetHeight),
          builder: (_, h, child) => SizedBox(height: h, child: child),
          child: const HomeSentenceCarousel(),
        ),

        const SizedBox(height: 8),

        // Sentence number + cycles
        HomeSentenceStats(
          viewIndex: viewIdx,
          cyclesDone: cyclesDone,
          cyclesTarget: cyclesTarget,
        ),

        const SizedBox(height: 8),

        // -------------------------------------------------------------------
        // 📊 PROGRESS BAR (now clearly visible even at 0 / 6)
        // -------------------------------------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6), // light cream track
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AmagamaColors.textSecondary,
                width: 1,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fraction,
                child: fraction == 0
                    ? const SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                          color: AmagamaColors.secondary, // green fill
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 🏆 Trophies row
        HomeTrophiesRow(
          bronze: bronze,
          silver: silver,
          gold: gold,
        ),

        const SizedBox(height: 20),

        // ▶ Play button
        const PlayButtonCentered(),

        const SizedBox(height: 12),

        // 🔒 Grown Ups
        const GrownUpsButton(),

        const SizedBox(height: 14),
      ],
    );
  }
}