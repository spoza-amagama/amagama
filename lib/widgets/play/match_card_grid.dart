// 📄 lib/widgets/play/match_card_grid.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/widgets/play/match_card_item.dart';
import 'package:amagama/services/audio/audio_service.dart';

/// 🧩 Responsive MatchCardGrid — all cards fit on a single screen
class MatchCardGrid extends StatelessWidget {
  final List<CardItem> cards;
  final VoidCallback onComplete;
  final bool fadeOut;

  const MatchCardGrid({
    super.key,
    required this.cards,
    required this.onComplete,
    this.fadeOut = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardCount = cards.length;

    // 🔢 Calculate grid shape to fit screen
    final crossAxisCount = (sqrt(cardCount)).ceil();
    const spacing = 8.0;

    final totalSpacing = spacing * (crossAxisCount + 1);
    final availableWidth = size.width - totalSpacing;
    final cardSize = availableWidth / crossAxisCount;

    final audio = AudioService();

    return Center(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(spacing),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 1.0, // square cards
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return SizedBox(
            width: cardSize,
            height: cardSize,
            child: MatchCardItem(
              key: ValueKey(card.id),
              card: card,
              fadeOut: fadeOut,
              sparkleKey: null,
              audioService: audio,
              onWord: (word) => audio.playWord(word),
              onComplete: (_) => onComplete(),
            ),
          );
        },
      ),
    );
  }
}