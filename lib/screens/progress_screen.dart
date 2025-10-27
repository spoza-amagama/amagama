import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/index.dart';
import '../data/index.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sentences.length,
        itemBuilder: (context, i) {
          final p = game.progress[i];
          final ratio = p.cyclesCompleted / game.cyclesTarget;
          final unlocked = game.isSentenceUnlocked(i);
          final color = unlocked ? Colors.green : Colors.grey.shade400;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Sentence ${i + 1}',
                          style: Theme.of(context).textTheme.titleMedium),
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
                    value: ratio,
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
