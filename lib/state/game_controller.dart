import 'dart:math';
import 'package:flutter/material.dart';
import '../data/index.dart';
import '../models/index.dart';
import '../services/index.dart';

class CardItem {
  final int id;              // unique per tile
  final String word;         // face
  final String avatarPath;   // back
  bool isFaceUp;
  bool isMatched;

  CardItem({
    required this.id,
    required this.word,
    required this.avatarPath,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

class GameController extends ChangeNotifier {
  final _storage = StorageService();
  final _audio = AudioService();
  final _rand = Random();

  AudioService get audioService => _audio;

  int _currentSentenceIndex = 0;
  int get currentSentenceIndex => _currentSentenceIndex;

  int _cyclesTarget = 6; // X (1..6)
  int get cyclesTarget => _cyclesTarget;

  List<SentenceProgress> _progress = [];
  List<SentenceProgress> get progress => _progress;

  List<CardItem> _deck = [];
  List<CardItem> get deck => _deck;

  CardItem? _firstPick;
  bool _busy = false;
  bool get busy => _busy;

  /// Initialize the game, preload audio, and rebuild the deck
  Future<void> init() async {
    // ✅ Preload all audio files once at startup
    await _audio.preloadAll();

    // Load saved state
    _currentSentenceIndex = await _storage.loadCurrentSentence();
    _progress = await _storage.loadProgress();
    _cyclesTarget = await _storage.loadCyclesTarget();

    // Ensure progress entries exist for all sentences
    final ids = _progress.map((e) => e.sentenceId).toSet();
    for (final s in sentences) {
      if (!ids.contains(s.id)) {
        _progress.add(SentenceProgress(
          sentenceId: s.id,
          cyclesCompleted: 0,
          trophyBronze: false,
          trophySilver: false,
          trophyGold: false,
        ));
      }
    }

    _progress.sort((a, b) => a.sentenceId.compareTo(b.sentenceId));
    await _storage.saveProgress(_progress);

    _buildDeck();
    notifyListeners();
  }

  /// ✅ Safe getter — never throws “Bad state: No element”
  SentenceProgress get currentProg {
    if (_progress.isEmpty) {
      final fallback = SentenceProgress(
        sentenceId: _currentSentenceIndex,
        cyclesCompleted: 0,
        trophyBronze: false,
        trophySilver: false,
        trophyGold: false,
      );
      _progress.add(fallback);
      _storage.saveProgress(_progress);
      return fallback;
    }

    final match = _progress.where((p) => p.sentenceId == _currentSentenceIndex);
    if (match.isEmpty) {
      final newProg = SentenceProgress(
        sentenceId: _currentSentenceIndex,
        cyclesCompleted: 0,
        trophyBronze: false,
        trophySilver: false,
        trophyGold: false,
      );
      _progress.add(newProg);
      _storage.saveProgress(_progress);
      return newProg;
    }

    return match.first;
  }

  bool isSentenceUnlocked(int idx) {
    if (idx == _currentSentenceIndex) return true;
    if (idx < _currentSentenceIndex) return true;
    if (idx == _currentSentenceIndex + 1) {
      return currentProg.cyclesCompleted >= _cyclesTarget;
    }
    return false;
  }

  void setCyclesTarget(int x) {
    _cyclesTarget = x.clamp(1, 6);
    _storage.saveCyclesTarget(_cyclesTarget);
    notifyListeners();
  }

  void _buildDeck() {
    final s = sentences[_currentSentenceIndex];
    final tokens = List<String>.from(s.words);
    tokens.shuffle(_rand);

    // Select 5 unique words
    final unique = <String>[];
    for (final w in tokens) {
      if (!unique.contains(w)) unique.add(w);
      if (unique.length == 5) break;
    }
    while (unique.length < 5) {
      unique.add(tokens[_rand.nextInt(tokens.length)]);
    }

    // Pair them and make 10 cards with random avatars
    final avatarPool = List<String>.from(avatarAssetPaths)..shuffle(_rand);
    final pickedAvatars = avatarPool.take(10).toList();

    final items = <CardItem>[];
    int id = 0;
    for (final w in unique) {
      for (int i = 0; i < 2; i++) {
        items.add(CardItem(
          id: id++,
          word: w,
          avatarPath: pickedAvatars.removeAt(0),
        ));
      }
    }
    items.shuffle(_rand);
    _deck = items;
    _firstPick = null;
  }

  Future<void> flip(CardItem item) async {
    if (_busy || item.isMatched || item.isFaceUp) return;
    item.isFaceUp = true;
    notifyListeners();

    if (_firstPick == null) {
      _firstPick = item;
      return;
    }

    _busy = true;
    if (_firstPick!.word == item.word) {
      await _audio.playMatch();
      _firstPick!.isMatched = true;
      item.isMatched = true;
      _firstPick = null;
      _busy = false;
      notifyListeners();
      _checkRoundComplete();
    } else {
      await _audio.playMismatch();
      await Future.delayed(const Duration(milliseconds: 700));
      _firstPick!.isFaceUp = false;
      item.isFaceUp = false;
      _firstPick = null;
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> _checkRoundComplete() async {
    final allMatched = _deck.every((c) => c.isMatched);
    if (!allMatched) return;

    final idx = _progress.indexWhere((p) => p.sentenceId == _currentSentenceIndex);
    if (idx == -1) return;

    var p = _progress[idx];
    final newCycles = (p.cyclesCompleted + 1).clamp(0, _cyclesTarget);
    bool tb = p.trophyBronze, ts = p.trophySilver, tg = p.trophyGold;

    if (newCycles == 2 && !tb) {
      tb = true;
      await _audio.playTrophyBronze();
    }
    if (newCycles == 4 && !ts) {
      ts = true;
      await _audio.playTrophySilver();
    }
    if (newCycles == 6 && !tg) {
      tg = true;
      await _audio.playTrophyGold();
    }

    p = p.copyWith(
      cyclesCompleted: newCycles,
      trophyBronze: tb,
      trophySilver: ts,
      trophyGold: tg,
    );
    _progress[idx] = p;

    // Unlock next sentence if needed
    if (p.cyclesCompleted >= _cyclesTarget) {
      if (_currentSentenceIndex < sentences.length - 1) {
        _currentSentenceIndex += 1;
      }
      await _storage.saveCurrentSentence(_currentSentenceIndex);
    }

    await _storage.saveProgress(_progress);
    _buildDeck();
    notifyListeners();
  }

  Future<void> jumpToSentence(int idx) async {
    if (!isSentenceUnlocked(idx)) return;
    _currentSentenceIndex = idx;
    await _storage.saveCurrentSentence(idx);
    _buildDeck();
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _storage.resetAll();
    _currentSentenceIndex = 0;
    _progress = [];
    await init();
  }
}
