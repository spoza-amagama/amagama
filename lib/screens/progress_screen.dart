// 📄 lib/screens/progress_screen.dart
//
// 🏆 ProgressScreen
// ------------------------------------------------------------
// Displays overall learning progress across all sentences.
//
// RESPONSIBILITIES
// • Shows per-sentence progress bars and trophy icons.
// • Reflects real-time data from [GameController.progress].
// • Indicates whether each sentence is unlocked.
// • Provides a clean scrollable layout.
//
// DEPENDENCIES
// • [GameController] via Provider.
// • [sentences] list from data/index.dart.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_controller.dart';
import '../data/index.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final total = sentences.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: total,
        itemBuilder: (context, i) {
          if (i >= game.progress.length) return const SizedBox.shrink();

          final p = game.progress[i];
          final ratio = game.cyclesTarget > 0
              ? p.cyclesCompleted / game.cyclesTarget
              : 0.0;
          final bool unlocked = i <= game.currentSentenceIndex;
          final color = unlocked ? Colors.green : Colors.grey.shade400;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Sentence ${i + 1}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      if (p.trophyGold)
                        const Icon(Icons.emoji_events_rounded,
                            color: Color(0xFFFFD700))
                      else if (p.trophySilver)
                        const Icon(Icons.emoji_events_rounded,
                            color: Color(0xFFC0C0C0))
                      else if (p.trophyBronze)
                        const Icon(Icons.emoji_events_rounded,
                            color: Color(0xFFCD7F32))
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sentences[i].text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: ratio.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${p.cyclesCompleted}/${game.cyclesTarget} cycles completed',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
