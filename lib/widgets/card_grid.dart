// 📄 lib/widgets/card_grid.dart
//
// 🧩 CardGrid
// ----------------------
// Displays the interactive grid of cards in the Play screen.
// Delegates game logic, glow handling, and audio playback
// to [CardGridController] while focusing only on layout and composition.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/widgets/card_cell.dart';
import 'package:amagama/controllers/card_grid_controller.dart';
import 'package:amagama/models/card_item.dart';

class CardGrid extends StatelessWidget {
  final void Function(String word)? onWordFlip;
  final void Function(String sentenceId)? onSentenceComplete;

  const CardGrid({
    super.key,
    this.onWordFlip,
    this.onSentenceComplete,
  });

  @override
  Widget build(BuildContext context) {
    final gridCtrl = context.watch<CardGridController>();
    final game = context.watch<GameController>();
    final sentence = sentences[game.currentSentenceIndex];
    final deck = game.deck;

    // 🔢 Compute dynamic responsive grid layout
    final layout = gridCtrl.computeGridLayout(
      boxSize: MediaQuery.of(context).size,
      totalCards: deck.length,
    );

    return Padding(
      padding: EdgeInsets.only(top: layout.topPadding, left: 8, right: 8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: deck.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: layout.cols,
          crossAxisSpacing: layout.spacing,
          mainAxisSpacing: layout.spacing,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final CardItem item = deck[index];
          final bool isMatched = gridCtrl.isMatched(item.id);
          final bool isGlowing = gridCtrl.isGlowing(item.id);

          return CardCell(
            item: item,
            isMatched: isMatched,
            isGlowing: isGlowing,
            size: layout.cardSize,
            lockInput: game.busy,
            onFlip: () async {
              await gridCtrl.handleFlip(context, item, sentence.id);

              // 🔊 Trigger external callbacks for word flip or sentence complete
              if (!item.isMatched) {
                onWordFlip?.call(item.word);
              }
              if (game.deck.every((c) => c.isMatched)) {
                onSentenceComplete?.call(sentence.id.toString());
              }
            },
          );
        },
      ),
    );
  }
}
