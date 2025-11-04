// 📄 lib/screens/settings_screen.dart
//
// ⚙️ SettingsScreen
// ------------------------------------------------------------
// Manages app configuration and game reset.
//
// RESPONSIBILITIES
// • Adjusts cycle targets.
// • Resets all saved progress.
// • Reloads the GameController after changes.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cycles per sentence',
                style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: game.cyclesTarget.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              label: '${game.cyclesTarget}',
              onChanged: (v) async {
                // Reload game with new cycle target
                game.setCyclesTarget(v.toInt());
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset All Progress'),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset All Progress?'),
                    content: const Text(
                        'This will erase your trophies and sentence progress.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) await game.resetAll();
              },
            ),
          ],
        ),
      ),
    );
  }
}
