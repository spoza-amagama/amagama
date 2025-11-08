// 📄 lib/widgets/play/animated_match_grid.dart
//
// 🎲 AnimatedMatchGrid — adaptive grid with animation
// ------------------------------------------------------------
// • Displays all cards using adaptive grid layout.
// • Handles only animation + rendering structure.
// • Delegates layout math to [computeAdaptiveLayout].
// • Delegates each card tile to [MatchCardTile].

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/controllers/card_grid_controller.dart';
import 'package:amagama/widgets/play/match_card_tile.dart';
import 'package:amagama/utils/grid_layout_helper.dart';

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
    // Watch game state for rebuilds
    context.watch<GameController>();
    final controller = context.read<CardGridController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = computeAdaptiveLayout(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          total: cards.length,
          isTablet: constraints.maxWidth > 700,
        );

        return AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.only(
            top: layout.topPad,
            left: 8,
            right: 8,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.center,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: layout.spacing,
                  runSpacing: layout.spacing,
                  children: [
                    for (final card in cards)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: layout.cardSize,
                        height: layout.cardSize,
                        child: MatchCardTile(
                          card: card,
                          controller: controller,
                          sentenceId: sentenceId,
                          totalCards: cards.length,
                          gridSize: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
