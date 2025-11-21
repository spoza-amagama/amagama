// 📄 lib/widgets/game_over/game_over_actions.dart
//
// 🎮 GameOverActions — primary actions for the Game Over screen:
// • Play again
// • Go home
// • View progress

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/routes/index.dart';

class GameOverActions extends StatelessWidget {
  final VoidCallback? onPlayAgain;
  final VoidCallback? onHome;
  final VoidCallback? onViewProgress;

  const GameOverActions({
    super.key,
    this.onPlayAgain,
    this.onHome,
    this.onViewProgress,
  });

  @override
  Widget build(BuildContext context) {
    // Provide sensible defaults if no callbacks are passed.
    final playAgain = onPlayAgain ??
        () => Navigator.of(context).pushReplacementNamed(AppRoutes.play);

    final goHome = onHome ??
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);

    final viewProgress = onViewProgress ??
        () => Navigator.of(context).pushNamed(AppRoutes.progress);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        children: [
          // ▶ Play Again
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.replay_rounded),
              onPressed: playAgain,
              style: AmagamaButtons.primary.copyWith(
                minimumSize:
                    const WidgetStatePropertyAll(Size.fromHeight(48)),
              ),
              label: const Text('Play again'),
            ),
          ),

          const SizedBox(height: 10),

          // 🏡 Back to home
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.home_rounded),
              onPressed: goHome,
              style: AmagamaButtons.secondary.copyWith(
                minimumSize:
                    const WidgetStatePropertyAll(Size.fromHeight(46)),
              ),
              label: const Text('Back to home'),
            ),
          ),

          const SizedBox(height: 10),

          // 📈 View progress
          TextButton.icon(
            onPressed: viewProgress,
            icon: const Icon(Icons.bar_chart_rounded),
            label: Text(
              'View progress',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}