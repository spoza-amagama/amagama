// 📄 lib/controllers/card_grid_controller.dart
//
// 🧩 CardGridController
// ------------------------------------------------------------
// Coordinates card-flip flow between GameController and UI.
// • Plays word audio on every flip except the final match
// • Plays full sentence audio when deck is complete
// • Handles glow/matched overlays and grid layout calculations
// ------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/services/audio/audio_service.dart';

class CardGridLayout {
  final double cardSize;
  final double spacing;
  final double topPadding;
  final int cols;
  final bool scrollable;

  const CardGridLayout({
    required this.cardSize,
    required this.spacing,
    required this.topPadding,
    required this.cols,
    required this.scrollable,
  });
}

class CardGridController extends ChangeNotifier {
  final AudioService _audio = AudioService();
  final Set<int> _matched = {};
  int? _glowCardId;
  String? _lastWord;

  // ---------------------------------------------------------------------------
  // 🔊 Main entry — handles tap + audio selection
  // ---------------------------------------------------------------------------
  Future<void> handleCardFlip({
    required BuildContext context,
    required CardItem item,
    required int sentenceId,
    required Size boxSize,
    required int totalCards,
  }) async {
    final game = context.read<GameController>();
    final beforeMatchedCount = game.deck.where((c) => c.isMatched).length;

    // perform core logic (no audio inside game controller)
    final result = await game.onCardTapped(item);

    // evaluate completion
    final allNowMatched = game.deck.every((c) => c.isMatched);
    final becameFinalByThisTap =
        (result == CardMatchResult.matched) &&
        (beforeMatchedCount + 2 == game.deck.length);

    // decide audio
    if (becameFinalByThisTap || allNowMatched) {
      // ✅ final pair — play sentence only
      await _waitForAudioQueue();
      await _audio.playSentence(sentenceId);
      _lastWord = null;
    } else {
      // 🎧 normal flip — play word
      await _waitForAudioQueue();
      await _audio.playWord(item.word);
      _lastWord = item.word;
    }

    // visuals
    switch (result) {
      case CardMatchResult.pending:
        _triggerGlow(item.id);
        break;
      case CardMatchResult.matched:
        final newlyMatched =
            game.deck.where((c) => c.isMatched).map((c) => c.id).toSet();
        _markMatched(newlyMatched);
        Future.delayed(const Duration(milliseconds: 600), () {
          _unmarkMatched(newlyMatched);
        });
        break;
      case CardMatchResult.mismatch:
        _glowCardId = null;
        notifyListeners();
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // 🎧 Helpers
  // ---------------------------------------------------------------------------
  Future<void> _waitForAudioQueue() async {
    while (_audio.isPlaying) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  // ---------------------------------------------------------------------------
  // ✨ Visual-state helpers
  // ---------------------------------------------------------------------------
  bool isMatched(int id) => _matched.contains(id);
  bool isGlowing(int id) => _glowCardId == id;

  void _triggerGlow(int id) {
    _glowCardId = id;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (_glowCardId == id) {
        _glowCardId = null;
        notifyListeners();
      }
    });
  }

  void _markMatched(Set<int> ids) {
    _matched.addAll(ids);
    notifyListeners();
  }

  void _unmarkMatched(Set<int> ids) {
    _matched.removeAll(ids);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 📐 Layout calculator used by AnimatedMatchGrid
  // ---------------------------------------------------------------------------
  CardGridLayout computeGridLayout({
    required Size boxSize,
    required int totalCards,
  }) {
    const spacing = 8.0;
    const topPadding = 16.0;

    int cols = (boxSize.width ~/ 100).clamp(2, 5);
    double cardSize =
        (boxSize.width - (cols + 1) * spacing) / cols;

    final rows = (totalCards / cols).ceil();
    final totalHeight = rows * (cardSize + spacing) + topPadding;
    final scrollable = totalHeight > boxSize.height;

    return CardGridLayout(
      cardSize: cardSize,
      spacing: spacing,
      topPadding: topPadding,
      cols: cols,
      scrollable: scrollable,
    );
  }
}
