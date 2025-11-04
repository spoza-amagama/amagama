// 📄 lib/widgets/card_flip_controller.dart
//
// 🎮 CardFlipController
// ------------------------------------------------------------
// Bridges the game controller logic and visual flip-card presentation.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/data/index.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/widgets/play/match_card_item.dart';
import 'package:amagama/services/audio/audio_service.dart';
import 'package:amagama/widgets/sparkle_layer.dart';

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
    final game = context.watch<GameController>();
    final sentence = sentences[game.currentSentenceIndex];
    final sparkleKey = GlobalKey<SparkleLayerState>();

    return SizedBox(
      width: size,
      height: size,
      child: MatchCardItem(
        card: item,
        fadeOut: item.isMatched,
        sparkleKey: sparkleKey,
        audioService: AudioService(),
        onWord: (_) {},
        onComplete: (_) async {
          if (game.deck.every((c) => c.isMatched)) {
            await AudioService().playSentence(sentence.id);
          }
        },
      ),
    );
  }
}
