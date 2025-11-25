// 📄 lib/widgets/grownups/set_cycles_dialog.dart
//
// SetCyclesDialog — allows parent to choose cycles per sentence (1–6).
// Updated to use white background number tiles and Amagama styling.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/state/game_controller.dart';
import 'package:amagama/theme/index.dart';

class SetCyclesDialog extends StatelessWidget {
  const SetCyclesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final current = game.cycles.cyclesTarget;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AmagamaColors.surface,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select cycles (1–6)",
              style: AmagamaTypography.titleStyle.copyWith(fontSize: 26),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // ------------------------------------------------------------
            // CUSTOM WHITE TILES (1–6)
            // ------------------------------------------------------------
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(6, (i) {
                final value = i + 1;
                final selected = current == value;

                return GestureDetector(
                  onTap: () async {
                    await game.cycles.setCyclesTarget(value);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? AmagamaColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: selected
                            ? AmagamaColors.primary
                            : AmagamaColors.textSecondary.withAlpha(80),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "$value",
                      style: AmagamaTypography.titleStyle.copyWith(
                        fontSize: 24,
                        color: selected
                            ? Colors.white
                            : AmagamaColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 28),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: AmagamaTypography.bodyStyle.copyWith(
                  color: AmagamaColors.accent,
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