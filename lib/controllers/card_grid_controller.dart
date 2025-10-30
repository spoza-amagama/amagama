// 📄 lib/controllers/card_grid_controller.dart
//
// 🧠 CardGridController
// ----------------------------------
// Centralized logic for card flipping, glowing, and sequential audio playback.
// Keeps CardGrid presentation widgets simple and stateless.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/services/audio_service.dart';

class CardGridController extends ChangeNotifier {
  final AudioService _audio = AudioService();
  final Set<int> _matchedCardIds = {};
  int? _glowingCardId;
  String? _lastPlayedWord;

    /// Layout parameters for the grid
  GridLayout computeGridLayout({
    required Size boxSize,
    required int totalCards,
  }) {
    final width = boxSize.width;
    final height = boxSize.height;
    final baseSpacing = width < 400 ? 8.0 : width < 600 ? 10.0 : 14.0;

    int bestCols = 2;
    int bestRows = (totalCards / bestCols).ceil();
    double bestCardSize = 0;

    for (int cols = 2; cols <= totalCards; cols++) {
      final rows = (totalCards / cols).ceil();

      final totalHSpacing = (cols - 1) * baseSpacing;
      final totalVSpacing = (rows - 1) * baseSpacing;

      // available space after margins and spacing
      final availableWidth = width - totalHSpacing - 16;
      final availableHeight = height - totalVSpacing - 32; // ✅ tighter padding

      if (availableWidth <= 0 || availableHeight <= 0) continue;

      // ✅ ensure card fits within both width *and* height
      final maxCardWidth = availableWidth / cols;
      final maxCardHeight = availableHeight / rows;
      final cardSize = maxCardWidth < maxCardHeight ? maxCardWidth : maxCardHeight;

      if (cols * rows >= totalCards && cardSize > bestCardSize) {
        bestCardSize = cardSize;
        bestCols = cols;
        bestRows = rows;
      }
    }

    // ✅ Don’t allow card size to exceed screen height division
    final safeCardSize = bestCardSize.clamp(40.0, height / (bestRows + 1));

    // ✅ Remove vertical centering — topPadding minimal
    const topPadding = 8.0;

    return GridLayout(
      cols: bestCols,
      rows: bestRows,
      spacing: baseSpacing,
      cardSize: safeCardSize,
      topPadding: topPadding,
    );
  }


  /// 🔄 Main flip handler — coordinates game + audio + glow
  Future<void> handleFlip(
    BuildContext context,
    CardItem item,
    int sentenceId,
  ) async {
    final game = context.read<GameController>();

    // Track matched state before flipping
    final beforeMatched =
        game.deck.where((c) => c.isMatched).map((c) => c.id).toSet();

    await game.flip(item);

    final allNowMatched = game.deck.every((c) => c.isMatched);

    if (!item.isMatched && item.isFaceUp && !allNowMatched) {
      await _playWord(item.word);
      _glowCard(item.id);
    }

    // Handle match highlights
    await _handleMatchedPair(game.deck, beforeMatched);

    if (allNowMatched) {
      await _waitForAudioQueue();
      await _audio.playSentence(sentenceId);
      _lastPlayedWord = null; // reset for next sentence
    }
  }

  /// 🎧 Sequentially play a single word (de-duplicates repeats)
  Future<void> _playWord(String word) async {
    if (_lastPlayedWord == word) return;
    _lastPlayedWord = word;

    await _waitForAudioQueue();
    await _audio.playWord(word);
  }

  /// 💡 Trigger glow animation on one card
  void _glowCard(int cardId) {
    _glowingCardId = cardId;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 800), () {
      _glowingCardId = null;
      notifyListeners();
    });
  }

  /// 🟩 Handle match pair highlighting
  Future<void> _handleMatchedPair(
      List<CardItem> deck, Set<int> beforeMatched) async {
    final afterMatched =
        deck.where((c) => c.isMatched).map((c) => c.id).toSet();
    final newMatches = afterMatched.difference(beforeMatched);

    if (newMatches.isEmpty) return;

    _matchedCardIds.addAll(newMatches);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _matchedCardIds.removeAll(newMatches);
    notifyListeners();
  }

  /// ⏳ Wait for queued audio to finish
  Future<void> _waitForAudioQueue() async {
    while (_audio.isPlaying) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  /// 🎯 Check if a card is matched or glowing
  bool isMatched(int id) => _matchedCardIds.contains(id);
  bool isGlowing(int id) => _glowingCardId == id;
}

/// Struct-like class to hold computed layout properties
class GridLayout {
  final int cols;
  final int rows;
  final double spacing;
  final double cardSize;
  final double topPadding;

  GridLayout({
    required this.cols,
    required this.rows,
    required this.spacing,
    required this.cardSize,
    required this.topPadding,
  });
}
