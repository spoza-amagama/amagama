// 📄 lib/widgets/play/play_layout.dart
// Lays out: sentence header + progress row + centered grid (AnimatedMatchGrid)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/widgets/sentence_header.dart';
import 'package:amagama/widgets/sparkle_layer.dart';
import 'package:amagama/widgets/play/animated_match_grid.dart';

class PlayLayout extends StatelessWidget {
  final AnimationController controller;
  final GlobalKey<SparkleLayerState> sparkleKey;
  final String sentenceText; // required

  const PlayLayout({
    super.key,
    required this.controller,
    required this.sparkleKey,
    required this.sentenceText,
  });

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final prog = game.currentProg;
    final cycles = '${prog.cyclesCompleted}/${game.cyclesTarget}';
    final sentenceNo = '${game.currentSentenceIndex + 1}/${game.progress.length}';

    return SafeArea(
      child: Column(
        children: [
          // Top sentence
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: SentenceHeader(text: sentenceText, controller: controller),
          ),

          // Sentence X of Y • Cycle X of Y — positioned under the sentence
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Sentence $sentenceNo • Cycle $cycles',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          // Bronze • Silver • Gold line sits below (keep your own widget if you have one)
          // SizedBox(height: 8), // space if needed

          // Grid takes remaining space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: AnimatedMatchGrid(
                cards: game.deck,
                sentenceId: prog.sentenceId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
