// 📄 lib/widgets/card_flip_controller.dart
//
// 🎮 CardFlipController
// ----------------------
// A lightweight bridge between [RoundCard] (UI) and the game logic.
// Delegates flipping, matching, and audio sequencing to
// [CardGridController] and [GameController].

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/controllers/card_grid_controller.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/widgets/round_card.dart';

class CardFlipController extends StatelessWidget {
  final CardItem item;
  final double size;

  const CardFlipController({
    super.key,
    required this.item,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final gridCtrl = context.read<CardGridController>();
    final game = context.watch<GameController>();
    final sentence = sentences[game.currentSentenceIndex];

    final bool isMatched = gridCtrl.isMatched(item.id);
    final bool isGlowing = gridCtrl.isGlowing(item.id);

    return RoundCard(
      item: item,
      size: size,
      avatarScale: 0.8,
      lockInput: game.busy,
      onFlip: () async {
        // 🂠 Flip logic handled by the controller
        await gridCtrl.handleFlip(context, item, sentence.id);

        // 🧠 Notify on word flip (if still unmatched)
        if (!item.isMatched && item.isFaceUp) {
          debugPrint("🔊 Word flipped: ${item.word}");
        }

        // 🏁 When all cards are matched, sentence audio will be played automatically
      },
    );
  }
}