// 📄 lib/widgets/game_over/game_over_header.dart
//
// Displays "You Did It!" header with African-themed styling.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class GameOverHeader extends StatelessWidget {
  const GameOverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('You Did It!',
      style: AmagamaTypography.textTheme.headlineLarge?.copyWith(
        color: AmagamaColors.textPrimary,
        shadows: [
          Shadow(
            color: AmagamaColors.accent.withValues(alpha: 0.4),
            blurRadius: 8,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}