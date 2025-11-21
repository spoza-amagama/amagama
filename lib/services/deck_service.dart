// 📄 lib/services/deck_service.dart
//
// DeckService — manages the card deck, selection state, and matching,
// delegating audio playback to AudioNotifier.
//
// Week-free, cycle-free, simplified for new Amagama architecture.
// - Deck resets only when sentence changes.
// - No cycle targets, no week multipliers.
// - Matching logic unchanged (clean & stable).
// - Safe guards for double-tap, async pauses, and race protection.
//

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

  // ---------------------------------------------------------------------------
  // INTERNAL STATE
  // ---------------------------------------------------------------------------

  List<CardItem> _deck = [];
  List<CardItem> get deck => _deck;

  final List<CardItem> _selected = [];

  bool _busy = false;
  bool get busy => _busy;

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------

  /// Build a fresh deck for the given sentence.
  Future<void> init(int sentenceIndex) async {
    _deck = _deckBuilder.buildDeckForSentence(sentenceIndex);
    _selected.clear();
    _busy = false;
  }

  /// Rebuilds the deck instantly when switching sentences.
  void resetForSentence(int sentenceIndex) {
    _deck = _deckBuilder.buildDeckForSentence(sentenceIndex);
    _selected.clear();
    _busy = false;
  }

  // ---------------------------------------------------------------------------
  // MATCHING LOGIC
  // ---------------------------------------------------------------------------

  bool get allMatched => _deck.every((c) => c.isMatched);

  Future<CardMatchResult> tap(CardItem card) async {
    // Ignore taps when busy or already matched
    if (_busy || card.isMatched) return CardMatchResult.pending;

    card.isFaceUp = true;
    _selected.add(card);

    // Brief reveal animation
    await Future.delayed(const Duration(milliseconds: 420));

    // Play word audio
    await _audio.playWord(card.word);

    // Need two cards to compare
    if (_selected.length < 2) {
      return CardMatchResult.pending;
    }

    _busy = true;

    final first = _selected[0];
    final second = _selected[1];

    // Match
    if (first.word == second.word) {
      first.isMatched = true;
      second.isMatched = true;
      _selected.clear();
      _busy = false;
      return CardMatchResult.matched;
    }

    // Mismatch
    await Future.delayed(const Duration(milliseconds: 900));
    first.isFaceUp = false;
    second.isFaceUp = false;

    _selected.clear();
    _busy = false;
    return CardMatchResult.mismatch;
  }

  // ---------------------------------------------------------------------------
  // HARD RESET
  // ---------------------------------------------------------------------------

  /// Clears all deck state. Used mainly during global reset.
  Future<void> reset() async {
    _deck = [];
    _selected.clear();
    _busy = false;
  }
}