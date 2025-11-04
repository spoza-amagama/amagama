// 📄 lib/services/deck_builder.dart
//
// 🧩 DeckBuilder
// ------------------------------------------------------------
// Builds shuffled decks of [CardItem]s for each sentence.
//
// RESPONSIBILITIES
// • Generates pairs of cards (two per word).
// • Assigns unique integer IDs for stable widget keys.
// • Shuffles deck for fair randomized gameplay.
//
// DEPENDENCIES
// • [CardItem] model for card data.
// • [sentences] dataset from Amagama’s curriculum.
//
// RELATED CLASSES
// • [GameController] — requests new decks.
// • [MatchCardGrid] / [AnimatedMatchGrid] — renders decks.
//

import 'dart:math';
import 'package:amagama/models/index.dart';
import 'package:amagama/data/index.dart';

class DeckBuilder {
  final _rng = Random();

  /// Builds a shuffled deck of cards for the given [sentenceIndex].
  List<CardItem> buildDeckForSentence(int sentenceIndex) {
    final sentence = sentences[sentenceIndex];
    final words = sentence.words;

    final List<CardItem> deck = [];
    int counter = 0;

    for (final w in words) {
      final id1 = sentence.id * 100 + counter++;
      final id2 = sentence.id * 100 + counter++;

      deck.add(CardItem(id: id1, word: w));
      deck.add(CardItem(id: id2, word: w));
    }

    deck.shuffle(_rng);
    return deck;
  }
}
