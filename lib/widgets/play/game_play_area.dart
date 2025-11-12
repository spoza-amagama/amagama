// 📄 lib/widgets/play/game_play_area.dart
//
// Encapsulates the main interactive gameplay zone using PlayBody (existing API).

import 'package:flutter/material.dart';
import '../../../theme/index.dart';
import '../../../state/game_controller.dart';
import 'play_body.dart';
import '../../../services/audio/audio_service.dart';

class GamePlayArea extends StatelessWidget {
  final GameController game;
  final AudioService audioService;
  final ValueChanged<String> onWord;
  final ValueChanged<dynamic> onComplete;

  const GamePlayArea({
    super.key,
    required this.game,
    required this.audioService,
    required this.onWord,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.sm,
      ),
      child: PlayBody(
        game: game,
        fadeOut: true,
        audioService: audioService,
        onWord: onWord,
        onComplete: onComplete,
      ),
    );
  }
}
