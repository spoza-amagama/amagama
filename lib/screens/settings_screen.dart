// /lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/index.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grown-Ups'),
        backgroundColor: const Color(0xFFFFC107),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(
              'Game Settings',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade700,
                  ),
            ),
            const SizedBox(height: 8),

            // 🧩 Adjust cycles target
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Cycles per sentence:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    DropdownButton<int>(
                      value: game.cyclesTarget,
                      items: List.generate(6, (i) {
                        final value = i + 1;
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }),
                      onChanged: (v) {
                        if (v != null) {
                          game.setCyclesTarget(v);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Maintenance',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade700,
                  ),
            ),
            const SizedBox(height: 8),

            // 🧹 Reset game card
            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.refresh_rounded,
                    color: Colors.redAccent),
                title: const Text(
                  'Reset Game Progress',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Erase all progress, trophies, and unlocks.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.redAccent),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Reset everything?'),
                      content: const Text(
                        'This will erase all progress, trophies, and locks. This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await game.resetAll();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Game has been reset.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 30),
            Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade700,
                  ),
            ),
            const SizedBox(height: 8),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const ListTile(
                leading: Icon(Icons.info_outline_rounded, color: Colors.brown),
                title: Text('Amagama Learning App'),
                subtitle: Text('Helping kids learn words with fun and play!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
