// 📄 lib/widgets/card_flip_controller.dart
//
// 🎮 CardFlipController
// Wraps a MatchCardItem, wiring it to GameController, AudioService and sparkles.

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
  final GlobalKey<SparkleLayerState> sparkleKey;

  const CardFlipController({
    super.key,
    required this.item,
    required this.sparkleKey,
  });

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final sentence = sentences[game.currentSentenceIndex];
    final audio = AudioService();

    return MatchCardItem(
      card: item,
      fadeOut: item.isMatched,
      sparkleKey: sparkleKey,
      audioService: audio,
      onWord: (_) {},
      onComplete: (_) async {
        final allMatched = game.deck.every((c) => c.isMatched);
        if (allMatched) {
          await audio.playSentence(sentence.id);
        }
      },
    );
  }
}