import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/widgets/card_cell.dart';
import 'package:amagama/controllers/card_grid_controller.dart';
import 'package:amagama/models/card_item.dart';

//
// 🧩 CardGrid (Self-Sizing Responsive Grid)
// ------------------------------------------------------------
// Displays the interactive grid of cards and delegates logic
// to [CardGridController]. Handles resize and rotation gracefully.
//

class CardGrid extends StatefulWidget {
  final void Function(String word)? onWordFlip;
  final void Function(String sentenceId)? onSentenceComplete;

  const CardGrid({
    super.key,
    this.onWordFlip,
    this.onSentenceComplete,
  });

  @override
  State<CardGrid> createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> with TickerProviderStateMixin {
  late final CardGridController _ctrl;
  late final AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = context.read<CardGridController>();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final sentence = sentences[game.currentSentenceIndex];
    final deck = game.deck;

    return LayoutBuilder(
      builder: (context, constraints) {
        final boxSize = Size(constraints.maxWidth, constraints.maxHeight);

        // 🔢 Compute responsive grid layout
        final layout = _ctrl.computeGridLayout(
          boxSize: boxSize,
          totalCards: deck.length,
        );

        _animCtrl.forward(from: 0);

        return AnimatedBuilder(
          animation: _animCtrl,
          builder: (context, _) {
            final t = Curves.easeInOut.transform(_animCtrl.value);

            return Padding(
              padding: EdgeInsets.only(
                top: layout.topPadding * t,
                left: 8,
                right: 8,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: layout.scrollable
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: deck.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: layout.cols,
                  crossAxisSpacing: layout.spacing * t,
                  mainAxisSpacing: layout.spacing * t,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final CardItem item = deck[index];
                  final bool isMatched = _ctrl.isMatched(item.id);
                  final bool isGlowing = _ctrl.isGlowing(item.id);

                  return AnimatedScale(
                    scale: isMatched ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: CardCell(
                      item: item,
                      isMatched: isMatched,
                      isGlowing: isGlowing,
                      size: layout.cardSize,
                      lockInput: game.busy,
                      onFlip: () async {
                        // 🂠 Flip handled by controller with named arguments
                        await _ctrl.handleCardFlip(
                          context: context,
                          item: item,
                          sentenceId: sentence.id,
                          boxSize: boxSize,
                          totalCards: deck.length,
                        );

                        // 🔊 Notify word flip
                        widget.onWordFlip?.call(item.word);

                        // 🏁 Notify completion when all cards matched
                        if (game.deck.every((c) => c.isMatched)) {
                          widget.onSentenceComplete
                              ?.call(sentence.id.toString());
                        }
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}