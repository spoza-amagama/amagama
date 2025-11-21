// 📄 lib/widgets/play/play_body.dart
//
// 🧩 PlayBody — displays the card grid for the current round,
// delegating game logic to GameController services.

import 'package:flutter/material.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/services/audio/audio_service.dart';

import 'animated_match_grid.dart';

class PlayBody extends StatelessWidget {
  final bool fadeOut;
  final AudioService audioService;
  final GameController game;
  final ValueChanged<String> onWord;
  final ValueChanged<dynamic> onComplete;

  const PlayBody({
    super.key,
    required this.fadeOut,
    required this.audioService,
    required this.game,
    required this.onWord,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final List<CardItem> cards = game.deck.deck;

    if (cards.isEmpty) {
      return const Center(
        child: Text(
          'No cards available',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    final sentenceIndex = game.sentences.currentSentence;

    return AnimatedMatchGrid(
      cards: cards,
      fadeOut: fadeOut,
      onCardTap: (card) async {
        // Notify footer which word to animate / play
        onWord(card.word);

        // Flip + match using DeckService
        await game.deck.tap(card);

        // Let RoundService handle completion + progression
        await game.rounds.handleRoundComplete();

        // Legacy hook
        onComplete(sentenceIndex);
      },
    );
  }
}