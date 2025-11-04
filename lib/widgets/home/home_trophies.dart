// 📄 lib/widgets/home/home_trophies.dart
//
// 🏆 HomeTrophies — visual indicator of progress and earned trophies.
// ------------------------------------------------------------
// Displays three trophy chips (bronze, silver, gold) plus an animated
// progress bar showing how many cycles have been completed for the
// current sentence.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/widgets/home/trophy_chip.dart';

class HomeTrophies extends StatelessWidget {
  const HomeTrophies({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final prog = game.progress[game.currentSentenceIndex];

    final cyclesDone = prog.cyclesCompleted;
    final totalCycles = game.cyclesTarget;
    final progress = (cyclesDone / totalCycles).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🏅 Trophy row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TrophyChip(
              icon: Icons.emoji_events,
              color: const Color(0xFFCD7F32), // bronze
              label: 'Bronze',
              earned: prog.trophyBronze,
            ),
            TrophyChip(
              icon: Icons.emoji_events,
              color: const Color(0xFFC0C0C0), // silver
              label: 'Silver',
              earned: prog.trophySilver,
            ),
            TrophyChip(
              icon: Icons.emoji_events,
              color: const Color(0xFFFFD700), // gold
              label: 'Gold',
              earned: prog.trophyGold,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 📊 Animated progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.orangeAccent.shade400,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Cycles: $cyclesDone / $totalCycles',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.brown.shade700,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
