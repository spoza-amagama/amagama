// 📄 lib/widgets/home/home_buttons.dart
//
// 🧩 HomeButtons — secondary row (Progress / Reset).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart'; // <-- updated: unified ConfirmDialog

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HomeActionButton(
          label: 'Progress',
          icon: Icons.bar_chart_rounded,
          color: AmagamaColors.secondary,
          onTap: () => Navigator.pushNamed(context, '/progress'),
        ),
        const SizedBox(width: 12),
        _HomeActionButton(
          label: 'Reset',
          icon: Icons.restart_alt_rounded,
          color: AmagamaColors.accent,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => ConfirmDialog(
                title: 'Reset Progress?',
                message:
                    'This will erase all trophies, cycles and sentence progress.',
                confirmLabel: 'Reset',
                destructive: true, // 🔥 matches action intent
                onConfirm: () async {
                  await context.read<GameController>().resetAll();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: AmagamaButtons.primary.copyWith(
          minimumSize: WidgetStateProperty.all(
            const Size.fromHeight(44),
          ),
          backgroundColor: WidgetStateProperty.all(
            color.withValues(alpha: 0.95),
          ),
        ),
      ),
    );
  }
}