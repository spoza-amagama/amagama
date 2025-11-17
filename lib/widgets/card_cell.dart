// 📄 lib/widgets/card_cell.dart
//
// 🧩 CardCell — visual wrapper for grid card instances.
// Delegates flip and match handling to CardGridController.
//
import 'package:flutter/material.dart';
import 'package:amagama/models/card_item.dart';
import 'package:amagama/widgets/play/match_card_item.dart';
import 'package:amagama/services/audio/audio_service.dart';
import 'package:amagama/widgets/sparkle_layer.dart';

class CardCell extends StatelessWidget {
  final CardItem item;
  final bool isMatched;
  final bool isGlowing;
  final double size;
  final bool lockInput;
  final VoidCallback onFlip;

  const CardCell({
    super.key,
    required this.item,
    required this.isMatched,
    required this.isGlowing,
    required this.size,
    required this.lockInput,
    required this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    final sparkleKey = GlobalKey<SparkleLayerState>();

    return AnimatedOpacity(
      opacity: isMatched ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 250),
      child: AnimatedScale(
        scale: isGlowing ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: lockInput || isMatched,
          child: MatchCardItem(
            card: item,
            fadeOut: isMatched,
            sparkleKey: sparkleKey,
            audioService: AudioService(),
            onWord: (_) {},
            onComplete: (_) => onFlip(),
          ),
        ),
      ),
    );
  }
}