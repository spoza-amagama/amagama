//
// 🧠 GameController — manages game play, progression, cycles,
// GLOBAL trophies, deck building, and viewSentenceIndex for UI.
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

  // ---------------------------------------------------------------------------
  // Sentence Indexing
  // ---------------------------------------------------------------------------
  int _currentSentenceIndex = 0;
  int get currentSentenceIndex => _currentSentenceIndex;

  int _viewSentenceIndex = 0;
  int get viewSentenceIndex => _viewSentenceIndex;

  void setViewSentenceIndex(int index) {
    _viewSentenceIndex = index;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Cycles + Progress
  // ---------------------------------------------------------------------------
  int _cyclesTarget = 6;
  int get cyclesTarget => _cyclesTarget;

  List<SentenceProgress> _progress = [];
  List<SentenceProgress> get progress => _progress;

  // ---------------------------------------------------------------------------
  // GLOBAL Trophy Totals
  // ---------------------------------------------------------------------------
  int totalBronze = 0;
  int totalSilver = 0;
  int totalGold = 0;

  // ⭐ One-shot flag for UI confetti
  bool _justUnlockedGold = false;
  bool get justUnlockedGold => _justUnlockedGold;
  void consumeGoldConfetti() => _justUnlockedGold = false;

  Future<void> _saveTrophyTotals() async {
    await _repo.saveTotalBronze(totalBronze);
    await _repo.saveTotalSilver(totalSilver);
    await _repo.saveTotalGold(totalGold);
  }

  // ---------------------------------------------------------------------------
  // Deck + Matching
  // ---------------------------------------------------------------------------
  List<CardItem> _deck = [];
  List<CardItem> get deck => _deck;

  final List<CardItem> _selected = [];
  bool _busy = false;
  bool get busy => _busy;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------
  Future<void> init() async {
    _currentSentenceIndex = await _repo.loadCurrentSentence();
    _viewSentenceIndex = _currentSentenceIndex;

    _cyclesTarget = await _repo.loadCyclesTarget();
    _progress = await _repo.loadProgress();

    // Load GLOBAL trophy totals
    totalBronze = await _repo.loadTotalBronze();
    totalSilver = await _repo.loadTotalSilver();
    totalGold = await _repo.loadTotalGold();

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

    _progress.sort((a, b) => a.sentenceId.compareTo(b.sentenceId));

    _deck = _deckBuilder.buildDeckForSentence(_currentSentenceIndex);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Card Matching
  // ---------------------------------------------------------------------------
  Future<CardMatchResult> onCardTapped(CardItem card) async {
    if (_busy || card.isMatched) return CardMatchResult.pending;

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
      first.isMatched = true;
      second.isMatched = true;
      _selected.clear();
      _busy = false;
      notifyListeners();
      await _onRoundComplete();
      return CardMatchResult.matched;
    }

    // mismatch
    await Future.delayed(const Duration(milliseconds: 900));
    first.isFaceUp = false;
    second.isFaceUp = false;
    _selected.clear();
    _busy = false;
    notifyListeners();
    return CardMatchResult.mismatch;
  }

  // ---------------------------------------------------------------------------
  // 🏆 Award Trophies
  // ---------------------------------------------------------------------------
  void _awardTrophies(int newCycles, SentenceProgress old) {
    bool awardBronze = false;
    bool awardSilver = false;
    bool awardGold = false;

    // Bronze: 2 cycles (first time only)
    if (newCycles >= 2 && !old.trophyBronze) {
      awardBronze = true;
      totalBronze += 1;
    }

    // Silver: 4 cycles (first time only)
    if (newCycles >= 4 && !old.trophySilver) {
      awardSilver = true;
      totalSilver += 1;
    }

    // Gold: 6 cycles (first time only)
    if (newCycles >= cyclesTarget && !old.trophyGold) {
      awardGold = true;
      totalGold += 1;
      _justUnlockedGold = true;
    }

    if (awardBronze || awardSilver || awardGold) {
      _saveTrophyTotals();
    }
  }

  // ---------------------------------------------------------------------------
  // Round Complete
  // ---------------------------------------------------------------------------
  Future<void> _onRoundComplete() async {
    if (_deck.any((c) => !c.isMatched)) return;

    final sentenceId = sentences[_currentSentenceIndex].id;
    final idx = _progress.indexWhere((p) => p.sentenceId == sentenceId);
    if (idx == -1) return;

    final old = _progress[idx];
    final newCycles = (old.cyclesCompleted + 1).clamp(0, _cyclesTarget);

    await _audioNotifier.playTrophy(newCycles);

    // Award global trophies based on NEW cycle count
    _awardTrophies(newCycles, old);

    // Update per-sentence flags
    _progress[idx] = old.copyWith(
      cyclesCompleted: newCycles,
      trophyBronze: old.trophyBronze || newCycles >= 2,
      trophySilver: old.trophySilver || newCycles >= 4,
      trophyGold: old.trophyGold || newCycles >= _cyclesTarget,
    );

    await _repo.saveProgress(_progress);

    // Unlock next sentence
    if (newCycles >= _cyclesTarget &&
        _currentSentenceIndex < sentences.length - 1) {
      _currentSentenceIndex++;
      _viewSentenceIndex = _currentSentenceIndex;
      await _repo.saveCurrentSentence(_currentSentenceIndex);
    }

    // Build fresh deck
    _deck = _deckBuilder.buildDeckForSentence(_currentSentenceIndex);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Sentence Switching
  // ---------------------------------------------------------------------------
  bool isSentenceUnlocked(int i) => i <= _currentSentenceIndex;

  void setCurrentSentenceIndex(int index) {
    if (index < 0 || index >= sentences.length) return;
    _currentSentenceIndex = index;
    _viewSentenceIndex = index;
    _deck = _deckBuilder.buildDeckForSentence(index);
    _repo.saveCurrentSentence(index);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Settings + Reset
  // ---------------------------------------------------------------------------
  Future<void> setCyclesTarget(int value) async {
    _cyclesTarget = value.clamp(1, 6);
    await _repo.saveCyclesTarget(_cyclesTarget);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _repo.resetAll();

    _currentSentenceIndex = 0;
    _viewSentenceIndex = 0;

    totalBronze = 0;
    totalSilver = 0;
    totalGold = 0;
    _justUnlockedGold = false;
    await _saveTrophyTotals();

    _progress = [];
    await init();
  }

  // ---------------------------------------------------------------------------
  // Legacy API
  // ---------------------------------------------------------------------------
  Future<void> finishSentence(BuildContext context) async {
    // no-op legacy
  }

  SentenceProgress get currentProg => _progress[_currentSentenceIndex];
}