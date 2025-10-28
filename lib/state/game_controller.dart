import 'dart:math';
import 'package:flutter/material.dart';
import '../data/index.dart';
import '../models/index.dart';
import '../services/index.dart';

/// Represents each card in the memory game.
class CardItem {
  final int id; // unique per tile
  final String word; // text on back
  final String avatarPath; // image on front
  bool isFaceUp;
  bool isMatched;
  bool shouldFlashRed; // 🔴 mismatch flash flag
  bool shouldJump; // 🟩 pulse for match
  bool shouldShake; // ❌ horizontal shake for mismatch

  CardItem({
    required this.id,
    required this.word,
    required this.avatarPath,
    this.isFaceUp = false,
    this.isMatched = false,
    this.shouldFlashRed = false,
    this.shouldJump = false,
    this.shouldShake = false,
  });
}

/// Controls game logic, progress, and deck state.
class GameController extends ChangeNotifier {
  final _storage = StorageService();
  final _audio = AudioService();
  final _rand = Random();

  AudioService get audioService => _audio;

  int _currentSentenceIndex = 0;
  int get currentSentenceIndex => _currentSentenceIndex;

  int _cyclesTarget = 6;
  int get cyclesTarget => _cyclesTarget;

  List<SentenceProgress> _progress = [];
  List<SentenceProgress> get progress => _progress;

  List<CardItem> _deck = [];
  List<CardItem> get deck => _deck;

  CardItem? _firstPick;
  bool _busy = false;
  bool get busy => _busy;

  /// Initialize the game, preload audio, and build the deck.
  Future<void> init() async {
    await _audio.preloadAll();

    _currentSentenceIndex = await _storage.loadCurrentSentence();
    _progress = await _storage.loadProgress();
    _cyclesTarget = await _storage.loadCyclesTarget();

    // Ensure progress entries exist for every sentence
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

  /// Safe getter — never throws.
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

  /// Builds a random deck of word–avatar pairs.
  void _buildDeck() {
    final s = sentences[_currentSentenceIndex];
    final tokens = List<String>.from(s.words);
    tokens.shuffle(_rand);

    // Pick up to 5 unique words
    final unique = <String>[];
    for (final w in tokens) {
      if (!unique.contains(w)) unique.add(w);
      if (unique.length == 5) break;
    }
    while (unique.length < 5) {
      unique.add(tokens[_rand.nextInt(tokens.length)]);
    }

    // Pair them with random avatars
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

  /// Handle a card flip — matching, flashing, shaking, or reverting.
  Future<void> flip(CardItem item) async {
    if (_busy || item.isMatched || item.isFaceUp) return;

    item.isFaceUp = true;
    notifyListeners();

    if (_firstPick == null) {
      _firstPick = item;
      return;
    }

    _busy = true;
    final other = _firstPick!;

    // ✅ MATCH
    if (other.word == item.word) {
      // await _audio.playMatch();
      other.isMatched = true;
      item.isMatched = true;

      // Subtle pulse jump
      other.shouldJump = true;
      item.shouldJump = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 250));
      other.shouldJump = false;
      item.shouldJump = false;

      _firstPick = null;
      _busy = false;
      notifyListeners();
      _checkRoundComplete();
      return;
    }

    // ❌ MISMATCH — both flash red, shake, and flip back
    // await _audio.playMismatch();

    // Allow a frame for both to appear face-up
    await Future.delayed(const Duration(milliseconds: 50));

    // Step 1: flash + shake
    other.shouldFlashRed = item.shouldFlashRed = true;
    other.shouldShake = item.shouldShake = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    // Step 2: stop shaking, keep red briefly
    other.shouldShake = item.shouldShake = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 200));

    // Step 3: reset + flip back
    other
      ..shouldFlashRed = false
      ..isFaceUp = false;
    item
      ..shouldFlashRed = false
      ..isFaceUp = false;

    _firstPick = null;
    _busy = false;
    notifyListeners();
  }

  /// Check if round complete and update trophies/unlocks.
  Future<void> _checkRoundComplete() async {
    final allMatched = _deck.every((c) => c.isMatched);
    if (!allMatched) return;

    final idx =
        _progress.indexWhere((p) => p.sentenceId == _currentSentenceIndex);
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

    if (p.cyclesCompleted >= _cyclesTarget &&
        _currentSentenceIndex < sentences.length - 1) {
      _currentSentenceIndex += 1;
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

  /// 🧠 NEW: Dynamic progress message for the end-of-round dialog
  String get progressMessage {
    final total = sentences.length;
    final current = _currentSentenceIndex + 1;
    final percent = ((current / total) * 100).round();
    return "You’ve mastered $current of $total sentences ($percent%)!";
  }
}
