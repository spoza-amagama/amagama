// 📄 lib/widgets/play/animated_match_grid.dart
//
// 🎲 AnimatedMatchGrid
// ------------------------------------------------------------
// Displays a responsive grid of [MatchFlipCard] widgets.
// Integrates glow and matched highlights from [CardGridController].
//
// RESPONSIBILITIES
// • Renders dynamic card grid layout per screen size.
// • Delegates card flipping and audio playback to controller.
// • Layers glow/match visual feedback over each card.
//
// DEPENDENCIES
// • [CardGridController] — orchestrates flip/audio/match state.
// • [CardGridGlow], [CardGridMatchedHighlight] — visual effects.
// • [MatchFlipCard] — interactive card widget.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/controllers/card_grid_controller.dart';
import 'package:amagama/widgets/play/match_flip_card.dart';
import 'package:amagama/widgets/play/card_grid_glow.dart';
import 'package:amagama/widgets/play/card_grid_matched_highlight.dart';

class AnimatedMatchGrid extends StatelessWidget {
  final List<CardItem> cards;
  final int sentenceId;

  const AnimatedMatchGrid({
    super.key,
    required this.cards,
    required this.sentenceId,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final controller = context.watch<CardGridController>();
        final layout = controller.computeGridLayout(
          boxSize: Size(constraints.maxWidth, constraints.maxHeight),
          totalCards: cards.length,
        );

        return GridView.builder(
          padding: EdgeInsets.only(top: layout.topPadding),
          physics: layout.scrollable
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout.cols,
            mainAxisSpacing: layout.spacing,
            crossAxisSpacing: layout.spacing,
            childAspectRatio: 1.0,
          ),
          itemCount: cards.length,
          itemBuilder: (context, i) {
            final card = cards[i];
            final isMatched = controller.isMatched(card.id);
            final isGlowing = controller.isGlowing(card.id);
            final sparkleKey = GlobalKey();

            return Stack(
              alignment: Alignment.center,
              children: [
                MatchFlipCard(
                  key: ValueKey(card.id),
                  card: card,
                  sparkleKey: sparkleKey,
                  onTap: () => controller.handleCardFlip(
                    context: context,
                    item: card,
                    sentenceId: sentenceId,
                    boxSize: Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                    totalCards: cards.length,
                  ),
                ),
                CardGridGlow(active: isGlowing),
                CardGridMatchedHighlight(visible: isMatched),
              ],
            );
          },
        );
      },
    );
  }
}