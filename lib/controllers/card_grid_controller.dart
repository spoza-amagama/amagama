// 📄 lib/controllers/card_grid_controller.dart
//
// 🧠 CardGridController (functional refactor)
// ------------------------------------------------------------
// Orchestrates layout, flip logic, and audio playback.
// Pure controller — no UI widgets defined here.
//
// RESPONSIBILITIES
// • Handles tap → flip → audio → match → sentence sequence.
// • Provides grid layout metrics.
// • Notifies listeners for glow/match visual triggers.
//
// DEPENDENCIES
// • [GameController] — manages card state.
// • [AudioService] — plays word and sentence audio.
//

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/services/audio/audio_service.dart';

class CardGridController extends ChangeNotifier {
  final AudioService _audio = AudioService();
  final Set<int> _matched = {};
  int? _glowCardId;
  String? _lastWord;

  final void Function(String word)? onWordFlip;
  final void Function(String sentenceId)? onSentenceComplete;

  CardGridController({this.onWordFlip, this.onSentenceComplete});

  // 🎯 Single orchestrating function
  Future<void> handleCardFlip({
    required BuildContext context,
    required CardItem item,
    required int sentenceId,
    required Size boxSize,
    required int totalCards,
  }) async {
    // Layout metrics are computed per frame
    final layout = computeGridLayout(boxSize: boxSize, totalCards: totalCards);
    debugPrint(
        '🧮 Layout: ${layout.cols}x${(totalCards / layout.cols).ceil()} • Card ${layout.cardSize}px');

    final game = context.read<GameController>();
    final beforeMatched =
        game.deck.where((c) => c.isMatched).map((c) => c.id).toSet();

    await game.onCardTapped(item);

    final allNowMatched = game.deck.every((c) => c.isMatched);

    // 🔊 Word playback
    if (!item.isMatched && item.isFaceUp && !allNowMatched) {
      if (_lastWord != item.word) {
        _lastWord = item.word;
        await _waitForAudioQueue();
        await _audio.playWord(item.word);
        onWordFlip?.call(item.word);
      }
      _triggerGlow(item.id);
    }

    // ✅ Matched feedback
    final afterMatched =
        game.deck.where((c) => c.isMatched).map((c) => c.id).toSet();
    final newMatches = afterMatched.difference(beforeMatched);
    if (newMatches.isNotEmpty) {
      _markMatched(newMatches);
      Future.delayed(
          const Duration(milliseconds: 600), () => _unmarkMatched(newMatches));
    }

    // 🗣️ Full sentence playback
    if (allNowMatched) {
      await _waitForAudioQueue();
      await _audio.playSentence(sentenceId);
      onSentenceComplete?.call(sentenceId.toString());
      _lastWord = null;
    }
  }

  // 📐 Layout Calculation
  CardGridLayout _computeLayout(Size size, int totalCards) {
    final w = size.width;
    final h = size.height;
    final spacing = w < 400
        ? 8
        : w < 600
            ? 10
            : 14;

    int cols = 2;
    int rows = (totalCards / cols).ceil();
    double cardSize = 0;

    for (int c = 2; c <= totalCards; c++) {
      final r = (totalCards / c).ceil();
      final availableW = w - (c - 1) * spacing - 16;
      final availableH = h - (r - 1) * spacing - 16;
      if (availableW <= 0 || availableH <= 0) continue;
      final estimate = (availableW / c).clamp(40.0, availableH / r);
      if (c * r >= totalCards && estimate > cardSize) {
        cols = c;
        rows = r;
        cardSize = estimate;
      }
    }

    final usedH = rows * cardSize + (rows - 1) * spacing;
    final topPadding = ((h - usedH) / 2).clamp(0.0, double.infinity);

    return CardGridLayout(
      cols: cols,
      cardSize: cardSize.clamp(50.0, 140.0),
      spacing: spacing.toDouble(),
      topPadding: topPadding,
      scrollable: usedH > h,
    );
  }

  // 🌐 Public API wrapper for UI widgets
  CardGridLayout computeGridLayout({
    required Size boxSize,
    required int totalCards,
  }) {
    return _computeLayout(boxSize, totalCards);
  }

  // 🧩 State Queries
  bool isMatched(int id) => _matched.contains(id);
  bool isGlowing(int id) => _glowCardId == id;

  // 🔊 Audio Sync
  Future<void> _waitForAudioQueue() async {
    while (_audio.isPlaying) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  // ✨ Glow + Match Handlers
  void _triggerGlow(int id) {
    _glowCardId = id;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 800), () {
      _glowCardId = null;
      notifyListeners();
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
}

// 📏 Grid layout data holder
class CardGridLayout {
  final int cols;
  final double cardSize;
  final double spacing;
  final double topPadding;
  final bool scrollable;

  const CardGridLayout({
    required this.cols,
    required this.cardSize,
    required this.spacing,
    required this.topPadding,
    required this.scrollable,
  });
}
