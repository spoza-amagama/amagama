// 📄 lib/widgets/play/match_card_tile.dart
// ------------------------------------------------------------
// 🧩 MatchCardTile
// Single card stack: flip card + overlays (glow/matched)
// Delegates flip/audio flow to CardGridController
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/controllers/card_grid_controller.dart';
import 'package:amagama/widgets/play/match_flip_card.dart';
import 'package:amagama/widgets/play/card_grid_glow.dart';
import 'package:amagama/widgets/play/card_grid_matched_highlight.dart';

class MatchCardTile extends StatelessWidget {
  final CardItem card;
  final CardGridController controller;
  final int sentenceId;
  final Size gridSize;
  final int totalCards;

  const MatchCardTile({
    super.key,
    required this.card,
    required this.controller,
    required this.sentenceId,
    required this.gridSize,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    final isMatched = controller.isMatched(card.id);
    final isGlowing = controller.isGlowing(card.id);

    return Stack(
      alignment: Alignment.center,
      children: [
        MatchFlipCard(
          key: ValueKey(card.id),
          card: card,
          onTap: () => controller.handleCardFlip(
            context: context,
            item: card,
            sentenceId: sentenceId,
            boxSize: gridSize,
            totalCards: totalCards,
          ),
        ),
        const IgnorePointer(child: SizedBox.shrink()),
        IgnorePointer(child: CardGridGlow(active: isGlowing)),
        IgnorePointer(child: CardGridMatchedHighlight(visible: isMatched)),
      ],
    );
  }
}
