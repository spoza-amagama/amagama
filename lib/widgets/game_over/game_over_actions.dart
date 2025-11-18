// 📄 lib/widgets/game_over/game_over_actions.dart
//
// Action buttons for GameOverScreen ("Play Again", "Home").
// Uses AmagamaColors and Spacing.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class GameOverActions extends StatelessWidget {
  const GameOverActions({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AmagamaTypography.textTheme;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AmagamaSpacing.md,
      runSpacing: AmagamaSpacing.sm,
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pushReplacementNamed(context, '/play'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AmagamaColors.secondary,
            padding: const EdgeInsets.symmetric(
              horizontal: AmagamaSpacing.lg,
              vertical: AmagamaSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AmagamaSpacing.radiusMd),
            ),
          ),
          icon: const Icon(Icons.replay_rounded),
          label: Text('Play Again',
            style: textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AmagamaColors.primary,
            side: const BorderSide(
              color: AmagamaColors.primary,
              width: 2,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AmagamaSpacing.lg,
              vertical: AmagamaSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AmagamaSpacing.radiusMd),
            ),
          ),
          icon: const Icon(Icons.home_rounded),
          label: Text('Home',
            style: textTheme.labelLarge?.copyWith(
              color: AmagamaColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}