// 📄 lib/widgets/home/home_buttons.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/game_controller.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Button(
            label: 'Play',
            icon: Icons.play_arrow_rounded,
            color: Colors.green,
            onTap: () => Navigator.pushNamed(context, '/play'),
          ),
          _Button(
            label: 'Progress',
            icon: Icons.bar_chart_rounded,
            color: Colors.blue,
            onTap: () => Navigator.pushNamed(context, '/progress'),
          ),
          _Button(
            label: 'Reset',
            icon: Icons.restart_alt_rounded,
            color: Colors.redAccent,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Reset all progress?'),
                  content: const Text(
                      'This will erase all your sentences, matches, and trophies.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Reset')),
                  ],
                ),
              );
              if (confirm == true) await game.resetAll();
            },
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _Button({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
      );
}
