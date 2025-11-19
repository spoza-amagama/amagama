// 📄 lib/widgets/play/game_play_area.dart
//
// Encapsulates the main interactive gameplay area using PlayBody.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/services/audio/audio_service.dart';

import 'play_body.dart';

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
        fadeOut: true,
        audioService: audioService,
        game: game,
        onWord: onWord,
        onComplete: onComplete,
      ),
    );
  }
}