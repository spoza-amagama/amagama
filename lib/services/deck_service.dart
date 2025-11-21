// 📄 lib/services/deck_service.dart
//
// DeckService — manages the card deck, selection state, and matching,
// delegating audio playback to AudioNotifier.
//
// NOTE: This service does NOT advance rounds by itself. It exposes
// enough state for a higher-level controller / RoundService to decide
// when a round is complete.

import 'dart:async';

import 'package:amagama/models/index.dart';
import 'package:amagama/services/audio_notifier.dart';
import 'package:amagama/services/deck_builder.dart';

enum CardMatchResult { pending, matched, mismatch }

class DeckService {
  final DeckBuilder _deckBuilder;
  final AudioNotifier _audio;

  DeckService({
    DeckBuilder? deckBuilder,
    AudioNotifier? audioNotifier,
  })  : _deckBuilder = deckBuilder ?? DeckBuilder(),
        _audio = audioNotifier ?? AudioNotifier();

  List<CardItem> _deck = [];
  List<CardItem> get deck => _deck;

  final List<CardItem> _selected = [];
  bool _busy = false;
  bool get busy => _busy;

  Future<void> init(int sentenceIndex) async {
    _deck = _deckBuilder.buildDeckForSentence(sentenceIndex);
    _selected.clear();
    _busy = false;
  }

  /// Resets deck for a sentence index (without async work).
  void resetForSentence(int sentenceIndex) {
    _deck = _deckBuilder.buildDeckForSentence(sentenceIndex);
    _selected.clear();
    _busy = false;
  }

  bool get allMatched => _deck.every((c) => c.isMatched);

  Future<CardMatchResult> tap(CardItem card) async {
    if (_busy || card.isMatched) return CardMatchResult.pending;

    card.isFaceUp = true;
    _selected.add(card);

    // Reveal briefly + play audio
    await Future.delayed(const Duration(milliseconds: 420));
    await _audio.playWord(card.word);

    if (_selected.length < 2) {
      return CardMatchResult.pending;
    }

    _busy = true;
    final first = _selected[0];
    final second = _selected[1];

    if (first.word == second.word) {
      first.isMatched = true;
      second.isMatched = true;
      _selected.clear();
      _busy = false;
      return CardMatchResult.matched;
    }

    // mismatch: flip back
    await Future.delayed(const Duration(milliseconds: 900));
    first.isFaceUp = false;
    second.isFaceUp = false;
    _selected.clear();
    _busy = false;
    return CardMatchResult.mismatch;
  }

  Future<void> reset() async {
    _deck = [];
    _selected.clear();
    _busy = false;
  }
}