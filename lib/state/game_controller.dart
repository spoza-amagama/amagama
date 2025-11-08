// 📄 lib/state/game_controller.dart
//
// 🧠 GameController
// ------------------------------------------------------------
// Core orchestrator for Amagama’s card matching gameplay.
//
// RESPONSIBILITIES
// • Manages a deck of [CardItem]s for the active sentence.
// • Handles taps, flip timing, and matching logic (no audio).
// • Advances to the next sentence when all matches are complete.
// • Emits notifications for UI rebuilds.
//
// DESIGN
// • Pure state manager: no UI helpers, text, or audio playback.
// • Widgets and controllers handle audio + visuals externally.
//

import 'package:flutter/material.dart';
import 'package:amagama/models/index.dart';
import 'package:amagama/repositories/game_repository.dart';
import 'package:amagama/services/deck_builder.dart';
import 'package:amagama/data/index.dart';

enum CardMatchResult { pending, matched, mismatch }

class GameController extends ChangeNotifier {
  final _repo = GameRepository();
  final _deckBuilder = DeckBuilder();

  int _currentSentenceIndex = 0;
  int _cyclesTarget = 6;
  List<SentenceProgress> _progress = [];
  List<CardItem> _deck = [];
  final List<CardItem> _selected = [];
  bool _busy = false;

  // 🔴 Notifier for mismatch flashing — observed by MatchFlipCard widgets
  final ValueNotifier<Set<int>> mismatchedCards = ValueNotifier({});

  int get currentSentenceIndex => _currentSentenceIndex;
  int get cyclesTarget => _cyclesTarget;
  List<CardItem> get deck => _deck;
  bool get busy => _busy;
  List<SentenceProgress> get progress => _progress;

  /// Initializes a new or saved game session.
  Future<void> init() async {
    _currentSentenceIndex = await _repo.loadCurrentSentence();
    _cyclesTarget = await _repo.loadCyclesTarget();
    _progress = await _repo.loadProgress();

    // Ensure every sentence has progress record
    final ids = _progress.map((p) => p.sentenceId).toSet();
    for (final s in sentences) {
      if (!ids.contains(s.id)) {
        _progress.add(
          SentenceProgress(
            sentenceId: s.id,
            cyclesCompleted: 0,
            trophyBronze: false,
            trophySilver: false,
            trophyGold: false,
          ),
        );
      }
    }

    _progress.sort((a, b) => a.sentenceId.compareTo(b.sentenceId));
    _deck = _deckBuilder.buildDeckForSentence(_currentSentenceIndex);
    notifyListeners();
  }

  /// Primary game loop: flip → evaluate → match/mismatch (no audio here).
  Future<CardMatchResult> onCardTapped(CardItem card) async {
    debugPrint('🎯 tapped ${card.word} (wasFaceUp=${card.isFaceUp})');
    if (_busy || card.isMatched) return CardMatchResult.pending;

    // Flip immediately
    card.isFaceUp = true;
    _selected.add(card);
    notifyListeners();

    // Wait for flip animation timing (approx.)
    await Future.delayed(const Duration(milliseconds: 420));

    // Only proceed when 2 cards are selected
    if (_selected.length < 2) return CardMatchResult.pending;

    _busy = true;
    final first = _selected[0];
    final second = _selected[1];

    if (first.word == second.word) {
      // ✅ Match found
      first.isMatched = true;
      second.isMatched = true;
      _selected.clear();
      _busy = false;
      notifyListeners();
      await _onRoundComplete();
      return CardMatchResult.matched;
    } else {
      // ❌ Mismatch — both cards flash red together before flipping back
      await Future.delayed(const Duration(milliseconds: 100));

      // Notify both mismatched cards to flash red
      mismatchedCards.value = {first.id, second.id};

      // Keep red flash visible
      await Future.delayed(const Duration(milliseconds: 300));

      // Clear mismatch signal
      mismatchedCards.value = {};

      // Wait a bit more before flipping them down
      await Future.delayed(const Duration(milliseconds: 500));

      first.isFaceUp = false;
      second.isFaceUp = false;
      _selected.clear();
      _busy = false;
      notifyListeners();

      return CardMatchResult.mismatch;
    }
  }

  /// Called when all cards in a deck are matched.
  Future<void> _onRoundComplete() async {
    if (_deck.any((c) => !c.isMatched)) return;

    final idx = _progress.indexWhere(
      (p) => p.sentenceId == _currentSentenceIndex,
    );
    if (idx == -1) return;

    var p = _progress[idx];
    final newCycles = (p.cyclesCompleted + 1).clamp(0, _cyclesTarget);

    _progress[idx] = p.copyWith(cyclesCompleted: newCycles);

    // Advance to next sentence when cycles complete
    if (p.cyclesCompleted >= _cyclesTarget &&
        _currentSentenceIndex < sentences.length - 1) {
      _currentSentenceIndex++;
      await _repo.saveCurrentSentence(_currentSentenceIndex);
    }

    await _repo.saveProgress(_progress);
    _deck = _deckBuilder.buildDeckForSentence(_currentSentenceIndex);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🩹 Public wrappers for UI compatibility
  // ---------------------------------------------------------------------------

  Future<void> setCyclesTarget(int value) async {
    _cyclesTarget = value.clamp(1, 6);
    await _repo.saveCyclesTarget(_cyclesTarget);
    notifyListeners();
  }

  Future<void> jumpToSentence(int idx) async {
    if (idx < 0 || idx >= sentences.length) return;
    _currentSentenceIndex = idx;
    await _repo.saveCurrentSentence(idx);
    _deck = _deckBuilder.buildDeckForSentence(idx);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _repo.resetAll();
    _currentSentenceIndex = 0;
    _progress = [];
    await init();
  }

  // ---------------------------------------------------------------------------
  // 🧩 Compatibility helpers
  // ---------------------------------------------------------------------------

  bool isSentenceUnlocked(int i) => i <= _currentSentenceIndex;
  SentenceProgress get currentProg => _progress[_currentSentenceIndex];
}
