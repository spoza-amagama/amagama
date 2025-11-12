// 📄 lib/screens/game_over_screen.dart
//
// 🎉 African-themed GameOverScreen
// Uses modular widgets for confetti, header, stats, and buttons.

import 'package:flutter/material.dart';
import '../../theme/index.dart';
import '../../widgets/game_over/index.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int badgesEarned;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.badgesEarned,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AmagamaColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // 🌈 Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AmagamaColors.secondary.withValues(alpha: 0.9),
                    AmagamaColors.primary.withValues(alpha: 0.85),
                    AmagamaColors.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // 🎊 Confetti
            const ConfettiLayer(),

            // 🌞 Content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AmagamaSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const GameOverHeader(),
                    const SizedBox(height: AmagamaSpacing.md),
                    GameOverStatsCard(
                      score: score,
                      badgesEarned: badgesEarned,
                    ),
                    const SizedBox(height: AmagamaSpacing.xl),
                    const GameOverActions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
