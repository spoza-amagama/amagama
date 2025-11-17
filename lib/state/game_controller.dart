// 📄 lib/state/game_controller.dart
//
// 🧠 GameController — orchestrates state for card-matching gameplay.
// ------------------------------------------------------------
// • Handles deck building, matching, audio, and progression
// • Tracks cycles, trophies, and per-sentence progress
// • Provides compatibility setters for UI components (carousel, progress list)
// • Works with repository persistence
//

import 'package:flutter/material.dart';
import 'package:amagama/models/index.dart';
import 'package:amagama/repositories/game_repository.dart';
import 'package:amagama/services/deck_builder.dart';
import 'package:amagama/services/audio_notifier.dart';
import 'package:amagama/data/index.dart';

enum CardMatchResult { pending, matched, mismatch }

class GameController extends ChangeNotifier {
  final _repo = GameRepository();
  final _deckBuilder = DeckBuilder();
  final _audioNotifier = AudioNotifier();

  int _currentSentenceIndex = 0;
  int _cyclesTarget = 6;
  List<SentenceProgress> _progress = [];
  List<CardItem> _deck = [];
  final List<CardItem> _selected = [];
  bool _busy = false;

  // ---------------------------------------------------------------------------
  // 📊 Getters
  // ---------------------------------------------------------------------------
  int get currentSentenceIndex => _currentSentenceIndex;
  int get cyclesTarget => _cyclesTarget;
  List<CardItem> get deck => _deck;
  bool get busy => _busy;
  List<SentenceProgress> get progress => _progress;

  // ---------------------------------------------------------------------------
  // 🚀 Initialization
  // ---------------------------------------------------------------------------
  Future<void> init() async {
    _currentSentenceIndex = await _repo.loadCurrentSentence();
    _cyclesTarget = await _repo.loadCyclesTarget();
    _progress = await _repo.loadProgress();

    // Ensure progress exists for all sentences
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

    // Sort by sentence id for stability
    _progress.sort((a, b) => a.sentenceId.compareTo(b.sentenceId));

    // Build initial deck
    _deck = _deckBuilder.buildDeckForSentence(_currentSentenceIndex);

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🂠 Matching Logic
  // ---------------------------------------------------------------------------
  Future<CardMatchResult> onCardTapped(CardItem card) async {
    if (_busy || card.isMatched) return CardMatchResult.pending;

    // Flip immediately
    card.isFaceUp = true;
    _selected.add(card);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 420));
    await _audioNotifier.playWord(card.word);

    if (_selected.length < 2) return CardMatchResult.pending;

    _busy = true;

    final first = _selected[0];
    final second = _selected[1];

    if (first.word == second.word) {
      // 🎉 MATCH
      first.isMatched = true;
      second.isMatched = true;
      _selected.clear();
      _busy = false;
      notifyListeners();
      await _onRoundComplete();
      return CardMatchResult.matched;
    } else {
      // ❌ MISMATCH
      await Future.delayed(const Duration(milliseconds: 900));
      first.isFaceUp = false;
      second.isFaceUp = false;
      _selected.clear();
      _busy = false;
      notifyListeners();
      return CardMatchResult.mismatch;
    }
  }

  // ---------------------------------------------------------------------------
  // 🏆 Round Completion
  // ---------------------------------------------------------------------------
  Future<void> _onRoundComplete() async {
    // Not complete yet?
    if (_deck.any((c) => !c.isMatched)) return;

    // FIXED: Progress lookup must use sentence.id, not index.
    final sentenceId = sentences[_currentSentenceIndex].id;

    final idx = _progress.indexWhere((p) => p.sentenceId == sentenceId);
    if (idx == -1) return;

    final old = _progress[idx];
    final newCycles = (old.cyclesCompleted + 1).clamp(0, _cyclesTarget);

    // Trophy sounds
    await _audioNotifier.playTrophy(newCycles);

    // Save updated progress
    _progress[idx] = old.copyWith(cyclesCompleted: newCycles);

    // Advance sentence when cycles target reached
    if (newCycles >= _cyclesTarget &&
        _currentSentenceIndex < sentences.length - 1) {
      _currentSentenceIndex++;
      await _repo.saveCurrentSentence(_currentSentenceIndex);
    }

    await _repo.saveProgress(_progress);

    // Rebuild deck
    _deck = _deckBuilder.buildDeckForSentence(_currentSentenceIndex);

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🩹 Public wrappers & compatibility helpers
  // ---------------------------------------------------------------------------

  /// Allows UI (e.g., carousel) to set a new current sentence without advancing cycles.
  void setCurrentSentenceIndex(int index) {
    if (index < 0 || index >= sentences.length) return;
    _currentSentenceIndex = index;
    _deck = _deckBuilder.buildDeckForSentence(index);
    notifyListeners();
  }

  /// Updates cycles target (1–6) and saves to repo.
  Future<void> setCyclesTarget(int value) async {
    _cyclesTarget = value.clamp(1, 6);
    await _repo.saveCyclesTarget(_cyclesTarget);
    notifyListeners();
  }

  /// UI helper used by screens to manually jump sentences.
  Future<void> jumpToSentence(int idx) async {
    if (idx < 0 || idx >= sentences.length) return;
    _currentSentenceIndex = idx;
    await _repo.saveCurrentSentence(idx);
    _deck = _deckBuilder.buildDeckForSentence(idx);
    notifyListeners();
  }

  /// Hard reset for settings screen.
  Future<void> resetAll() async {
    await _repo.resetAll();
    _currentSentenceIndex = 0;
    _progress = [];
    await init();
  }

  /// Returns true if the given sentence has reached its cycle target.
  bool progressBySentenceId(dynamic sentenceId) {
    final p = _progress.firstWhere(
      (p) => p.sentenceId == sentenceId,
      orElse: () => SentenceProgress(
        sentenceId: sentenceId,
        cyclesCompleted: 0,
        trophyBronze: false,
        trophySilver: false,
        trophyGold: false,
      ),
    );
    return p.cyclesCompleted >= _cyclesTarget;
  }

  /// Legacy hook: now sits idle because advancement happens automatically.
  Future<void> finishSentence(BuildContext context) async {
    // no-op (kept for backward compatibility)
  }

  // ---------------------------------------------------------------------------
  // 🔎 Additional helpers
  // ---------------------------------------------------------------------------

  bool isSentenceUnlocked(int i) => i <= _currentSentenceIndex;

  SentenceProgress get currentProg => _progress[_currentSentenceIndex];
}