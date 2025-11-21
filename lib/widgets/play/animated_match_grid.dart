// 📄 lib/widgets/play/animated_match_grid.dart
//
// 🎲 AnimatedMatchGrid (Updated for new CardGrid Architecture)
// ------------------------------------------------------------
// • Uses CardGridController for layout
// • Uses CardCell for rendering
// • No deprecated helpers (GridLayoutHelper, MatchFlipCard, etc.)
// • Pure presentation: no game logic here
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/models/card_item.dart';
import 'package:amagama/controllers/card_grid_controller.dart';
import 'package:amagama/widgets/card_cell.dart';

class AnimatedMatchGrid extends StatelessWidget {
  final List<CardItem> cards;
  final bool fadeOut;
  final void Function(CardItem) onCardTap;

  const AnimatedMatchGrid({
    super.key,
    required this.cards,
    required this.fadeOut,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final grid = context.watch<CardGridController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = grid.computeGridLayout(
          boxSize: Size(constraints.maxWidth, constraints.maxHeight),
          totalCards: cards.length,
        );

        return GridView.builder(
          padding: EdgeInsets.only(top: layout.topPadding),
          physics: layout.scrollable
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout.cols,
            crossAxisSpacing: layout.spacing,
            mainAxisSpacing: layout.spacing,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];

            // CardGridController APIs expect String IDs
            final isMatched = grid.isMatched(card.id.toString());
            final isGlowing = grid.isGlowing(card.id.toString());

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: fadeOut && isMatched ? 0.35 : 1.0,
              child: CardCell(
                item: card,
                isMatched: isMatched,
                isGlowing: isGlowing,
                size: layout.cardSize,
                lockInput: false,
                onFlip: () => onCardTap(card),
              ),
            );
          },
        );
      },
    );
  }
}