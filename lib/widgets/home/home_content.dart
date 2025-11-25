// 📄 lib/widgets/home/home_content.dart
//
// 🏡 HomeContent — week-free simplified Home screen body.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/utils/sentence_height.dart';

import 'home_header.dart';
import 'sentences/home_sentence_header.dart';
import 'sentences/home_sentence_carousel.dart';
import 'actions/play_button_centered.dart';
import 'package:amagama/widgets/home/actions/grownups_button.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // ---------------------------------------------------------------------------
    // LOADING STATES
    // ---------------------------------------------------------------------------

    if (!game.sentences.ready) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(
              strokeWidth: 4,
              color: AmagamaColors.warning,
            ),
            SizedBox(height: 12),
            Text(
              'Loading sentences…',
              style: TextStyle(
                fontSize: 16,
                color: AmagamaColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    if (game.sentences.total == 0) {
      return const Center(
        child: Text(
          'No sentences available.',
          style: TextStyle(
            fontSize: 16,
            color: AmagamaColors.textPrimary,
          ),
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // MAIN CONTENT
    // ---------------------------------------------------------------------------

    // ✅ use VIEW index so scrolling carousel updates the header
    final int idx = game.sentences.viewSentence;
    final sentence = game.sentences.byIndex(idx);

    final sentenceHeight = SentenceHeight.of(context, sentence.text);

    // Progress for this sentence (based on ACTIVE sentence)
    final activeIndex = game.sentences.currentSentence;
    final prog = game.progress.byIndex(activeIndex);

    final cyclesTarget = game.cycles.cyclesTarget;
    final currentCycles = prog.cyclesCompleted.clamp(0, cyclesTarget);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Trophy summary + per-sentence progress bar
          HomeHeader(game: game),

          const SizedBox(height: AmagamaSpacing.lg),

          // -------------------------------------------------------------------
          // Sentence header: “Sentence X of Y” (centered)
          // -------------------------------------------------------------------
          HomeSentenceHeader(
            sentenceNumber: idx + 1, // <= dynamic view index
            totalSentences: game.sentences.total,
          ),

          // -------------------------------------------------------------------
          // Cycle header: “Cycle X of Y” (always shows CURRENT gameplay progress)
          // -------------------------------------------------------------------
          if (cyclesTarget > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Cycle $currentCycles of $cyclesTarget',
              textAlign: TextAlign.center,
              style: AmagamaTypography.bodyStyle.copyWith(
                fontSize: 16,
                color: AmagamaColors.textPrimary,
              ),
            ),
            const SizedBox(height: AmagamaSpacing.md),
          ] else
            const SizedBox(height: AmagamaSpacing.md),

          // -------------------------------------------------------------------
          // Sentence preview (carousel handles view-only interaction)
          // -------------------------------------------------------------------
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