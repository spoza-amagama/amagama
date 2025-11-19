// 📄 lib/widgets/grownups/grownup_menu_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/theme/index.dart';
import 'confirm_dialog.dart';
import 'set_cycles_dialog.dart';
import 'settings_tile.dart';

class GrownupMenuDialog extends StatelessWidget {
  const GrownupMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: AmagamaColors.surface,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Grown Ups",
              style: AmagamaTypography.titleStyle.copyWith(fontSize: 30),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage cycles, progress and PIN.",
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            SettingsTile(
              icon: Icons.repeat_rounded,
              label: "Set cycles per sentence",
              color: AmagamaColors.secondary,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => const SetCyclesDialog(),
                );
              },
            ),

            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.restart_alt_rounded,
              label: "Reset all progress",
              color: AmagamaColors.accent,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => ConfirmDialog(
                    title: "Reset Progress?",
                    message:
                        "This will erase all trophies, cycles and sentence progress.",
                    confirmLabel: "Reset",
                    onConfirm: () => game.resetAll(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.lock_reset_rounded,
              label: "Reset parental PIN",
              color: AmagamaColors.primary,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => ConfirmDialog(
                    title: "Reset PIN?",
                    message:
                        "This will clear the parental PIN. You will create a new PIN next time.",
                    confirmLabel: "Reset PIN",
                    onConfirm: () => game.pin.reset(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: AmagamaTypography.bodyStyle.copyWith(
                  color: AmagamaColors.textSecondary,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}