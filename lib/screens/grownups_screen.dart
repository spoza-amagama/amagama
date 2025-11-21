// 📄 lib/screens/grownups_screen.dart
//
// 👨‍👩‍👧 Grown Ups Screen — Settings & Controls
// ------------------------------------------------------------
// • Reset ALL progress
// • Change parental PIN
// • Configure cyclesTarget (2–6) for each sentence
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/grownups/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/services/cycle_service.dart';

class GrownupsScreen extends StatelessWidget {
  const GrownupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final currentCycles = game.cycles.cyclesTarget;

    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Grown Ups',
              subtitle: 'Settings & Controls',
              showLogo: false,
              leadingAction: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // 🔵 CYCLES TARGET CONTROL (NEW)
            // ============================================================
            const SettingsSectionHeader(title: 'Gameplay Settings'),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AmagamaSpacing.md,
                vertical: AmagamaSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cycles per sentence',
                    style: AmagamaTypography.titleStyle.copyWith(
                      fontSize: 18,
                      color: AmagamaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Each sentence must be completed this many times\n'
                    'before the next one unlocks.',
                    style: AmagamaTypography.bodyStyle.copyWith(
                      color: AmagamaColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Text('${CycleService.minCycles}',
                          style: AmagamaTypography.bodyStyle),
                      Expanded(
                        child: Slider(
                          value: currentCycles.toDouble(),
                          min: CycleService.minCycles.toDouble(),
                          max: CycleService.maxCycles.toDouble(),
                          divisions: CycleService.maxCycles -
                              CycleService.minCycles,
                          label: '$currentCycles',
                          onChanged: (value) {
                            context
                                .read<GameController>()
                                .updateCyclesTarget(value.round());
                          },
                        ),
                      ),
                      const Text('${CycleService.maxCycles}',
                          style: AmagamaTypography.bodyStyle),
                    ],
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Current: $currentCycles cycles',
                      style: AmagamaTypography.bodyStyle.copyWith(
                        color: AmagamaColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ============================================================
            // 🔴 RESET ALL PROGRESS
            // ============================================================
            const SettingsSectionHeader(title: 'Maintenance'),

            SettingsTile(
              icon: Icons.delete_forever,
              label: 'Reset all progress',
              color: Colors.red.shade700,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => ConfirmDialog(
                    title: 'Reset all progress?',
                    message:
                        'This will erase ALL progress and cannot be undone.',
                    confirmLabel: 'Reset',
                    destructive: true,
                    onConfirm: () async {
                      await context.read<GameController>().resetAll();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All progress has been reset.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // ============================================================
            // 🟢 CHANGE PARENTAL PIN
            // ============================================================
            SettingsTile(
              icon: Icons.lock_reset,
              label: 'Change parental PIN',
              color: AmagamaColors.secondary,
              onTap: () async {
                final pinService = context.read<GameController>().pin;
                final currentPin = pinService.currentPin;

                // 1️⃣ Verify existing PIN (if one is set)
                if (currentPin != null) {
                  final verified = await showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => PinEntryFlow(
                      title: 'Enter current PIN',
                      verifyAgainst: currentPin,
                      onComplete: (pin) => Navigator.pop(context, pin),
                    ),
                  );
                  if (verified == null) return;
                }

                // 2️⃣ Enter new PIN
                final newPin = await showDialog<String>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => PinEntryFlow(
                    title: currentPin == null
                        ? 'Create a new PIN'
                        : 'Enter new PIN',
                    enforceLengthOnly: true,
                    onComplete: (pin) => Navigator.pop(context, pin),
                  ),
                );

                if (newPin == null) return;
                await pinService.setPin(newPin);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Parental PIN updated.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}