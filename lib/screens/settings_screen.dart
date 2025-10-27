import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/index.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    int currentX = game.cyclesTarget;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grown-Ups Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cycles per sentence',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Change how many times each sentence must be completed '
              'before the next one unlocks (1–6).',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Slider(
              value: currentX.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              label: '$currentX',
              onChanged: (v) {
                currentX = v.toInt();
                game.setCyclesTarget(currentX);
              },
            ),
            const SizedBox(height: 16),
            Text('Current setting: ${game.cyclesTarget} cycles',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
