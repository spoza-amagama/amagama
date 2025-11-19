// 📄 lib/widgets/home/home_header.dart
//
// 🧩 HomeHeader — top section of the Home Screen.

import 'package:flutter/material.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/theme/index.dart';

import 'home_trophies.dart';

class HomeHeader extends StatelessWidget {
  final GameController game;

  const HomeHeader({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final idx = game.sentences.currentSentence;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Amagama',
              style: AmagamaTypography.titleStyle.copyWith(
                fontSize: 28,
                color: AmagamaColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              'Sentence ${idx + 1}/${game.sentences.total}',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: AmagamaSpacing.sm),

        // Award summary
        const HomeTrophies(),
      ],
    );
  }
}