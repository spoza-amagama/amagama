// 📄 lib/widgets/play/animated_match_grid.dart
//
// 🎲 AnimatedMatchGrid
// ------------------------------------------------------------
// Renders a responsive grid of [MatchFlipCard] widgets.
// Uses [GridLayoutHelper] for layout calculations.
//
// RESPONSIBILITIES
// • Layout cards responsively based on available size.
// • Render flip cards with glow + matched highlight.
// • Delegate tap handling to the parent via [onCardTap].
//
// NOTE
// • No direct dependency on GameController or services.
// • All game logic lives in the caller (e.g. PlayBody).
//

import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/widgets/grid_layout_helper.dart';
import 'package:amagama/widgets/play/match_flip_card.dart';
import 'package:amagama/widgets/play/card_grid_glow.dart';
import 'package:amagama/widgets/play/card_grid_matched_highlight.dart';

class AnimatedMatchGrid extends StatelessWidget {
  final List<CardItem> cards;
  final int sentenceIndex;
  final bool fadeOut;
  final void Function(CardItem) onCardTap;

  const AnimatedMatchGrid({
    super.key,
    required this.cards,
    required this.sentenceIndex,
    required this.fadeOut,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = GridLayoutHelper.calculate(
          constraints.maxWidth,
          constraints.maxHeight,
          cards.length,
        );

        return GridView.builder(
          padding: EdgeInsets.only(top: layout.topPadding),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout.cols,
            mainAxisSpacing: layout.spacing,
            crossAxisSpacing: layout.spacing,
            childAspectRatio: 1.0,
          ),
          itemCount: cards.length,
          itemBuilder: (context, i) {
            final card = cards[i];
            final isMatched = card.isMatched;
            final isFaceUp = card.isFaceUp;
            final sparkleKey = GlobalKey();

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: fadeOut && isMatched ? 0.35 : 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MatchFlipCard(
                    key: ValueKey(card.id),
                    card: card,
                    sparkleKey: sparkleKey,
                    onTap: () => onCardTap(card),
                  ),
                  CardGridGlow(active: isFaceUp && !isMatched),
                  CardGridMatchedHighlight(visible: isMatched),
                ],
              ),
            );
          },
        );
      },
    );
  }
}