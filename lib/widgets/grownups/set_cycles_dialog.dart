// 📄 lib/widgets/grownups/set_cycles_dialog.dart
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
            const SizedBox(height: 24),

            Wrap(
              spacing: 12,
              children: List.generate(6, (i) {
                final value = i + 1;
                final selected = current == value;
                return ChoiceChip(
                  label: Text(
                    value.toString(),
                    style: AmagamaTypography.bodyStyle.copyWith(
                      color: selected
                          ? Colors.white
                          : AmagamaColors.textPrimary,
                    ),
                  ),
                  selected: selected,
                  selectedColor: AmagamaColors.primary,
                  onSelected: (_) {
                    game.cycles.setCyclesTarget(value);
                    Navigator.pop(context);
                  },
                );
              }),
            ),

            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}