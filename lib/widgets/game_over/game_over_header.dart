// 📄 lib/widgets/game_over/game_over_header.dart
//
// 🏁 GameOverHeader — title + short summary text for Game Over screen.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class GameOverHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const GameOverHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AmagamaTypography.titleStyle.copyWith(
            fontSize: 32,
            color: AmagamaColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AmagamaTypography.bodyStyle.copyWith(
            fontSize: 16,
            color: AmagamaColors.textSecondary,
          ),
        ),
      ],
    );
  }
}