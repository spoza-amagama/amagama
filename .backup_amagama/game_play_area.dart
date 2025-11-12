// 📄 lib/widgets/play/game_play_area.dart
//
// Main gameplay area styled with African theme padding and colors.

import 'package:flutter/material.dart';
import '../../../state/game_controller.dart';
import '../../../widgets/play/play_body.dart';
import '../../../theme/index.dart';

class GamePlayArea extends StatelessWidget {
  final GameController controller;
  final ValueChanged<String> onWord;
  final VoidCallback onComplete;

  const GamePlayArea({
    super.key,
    required this.controller,
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
      child: Container(
        decoration: BoxDecoration(
          color: AmagamaColors.background,
          borderRadius: BorderRadius.circular(AmagamaSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AmagamaColors.secondary.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: PlayBody(
          sentence: controller.currentSentence,
          onWord: onWord,
          onComplete: onComplete,
        ),
      ),
    );
  }
}
