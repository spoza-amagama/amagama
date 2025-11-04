// 📄 lib/screens/play_screen.dart
//
// 🎮 PlayScreen
// ------------------------------------------------------------
// Main interactive screen for matching cards in each sentence.
//
// RESPONSIBILITIES
// • Displays the current sentence and learning cycle progress.
// • Hosts the AnimatedMatchGrid for matching gameplay.
// • Handles taps via GameController.onCardTapped().
// • Uses Provider for live game state updates.
//
// DEPENDENCIES
// • [GameController], [AnimatedMatchGrid], [CycleProgressBar],
//   [SentenceUnlockIndicator], [ProgressMessage].
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/widgets/play/index.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final sentenceId = game.currentSentenceIndex;
    final sentence = sentences[sentenceId];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sentence ${sentenceId + 1}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SentenceUnlockIndicator(index: sentenceId),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Text(
                sentence.text,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const CycleProgressBar(),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedMatchGrid(
                  cards: game.deck,
                  sentenceId: game.currentSentenceIndex,
                ),
              ),
              const SizedBox(height: 12),
              const ProgressMessage(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
