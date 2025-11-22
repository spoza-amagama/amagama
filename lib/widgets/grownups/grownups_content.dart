// 📄 lib/widgets/grownups/grownups_content.dart
//
// GrownupsContent — main content for Grown Ups screen.
// ------------------------------------------------------------
// • Cycles per sentence → opens CyclesSettingsScreen
// • Reset all progress
// • Change parental PIN (new PIN flow API)
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amagama/theme/index.dart';
import 'package:amagama/routes/index.dart';
import 'package:amagama/state/game_controller.dart';
import 'package:amagama/services/pin_service.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/grownups/settings_tile.dart';
import 'package:amagama/widgets/grownups/settings_section_header.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_entry_flow.dart';

class GrownupsContent extends StatelessWidget {
  const GrownupsContent({super.key});

  // ---------------------------------------------------------------------------
  // HELPERS — New PIN entry dialogs using modern PinEntryFlow
  // ---------------------------------------------------------------------------

  Future<bool> _verifyPin(BuildContext context, String correctPin) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PinEntryFlow(
        title: 'Enter current PIN',
        verifyAgainst: correctPin,
        onComplete: (pin) => Navigator.pop(context, pin),
        onFailedAttempt: () => PinService().registerFail(),
        showForgotPin: false,
      ),
    );

    return result != null;
  }

  Future<String?> _createPin(BuildContext context, bool isNew) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PinEntryFlow(
        title: isNew ? 'Create a new PIN' : 'Enter new PIN',
        enforceLengthOnly: true,
        onComplete: (pin) => Navigator.pop(context, pin),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final pinService = PinService();

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.md,
      ),
      children: [
        // ------------------------------------------------------------
        // GAMEPLAY
        // ------------------------------------------------------------
        const SettingsSectionHeader(title: 'Gameplay'),

        SettingsTile(
          icon: Icons.repeat_rounded,
          label: 'Cycles per sentence',
          color: AmagamaColors.primary,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cyclesSettings);
          },
        ),

        const const SizedBox(height: AmagamaSpacing.md),

        // ------------------------------------------------------------
        // PROGRESS
        // ------------------------------------------------------------
        const SettingsSectionHeader(title: 'Progress'),

        SettingsTile(
          icon: Icons.delete_forever_rounded,
          label: 'Reset all progress',
          color: Colors.red,
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
                  await game.resetAll();
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const const SnackBar(
                      content: const Text('All progress has been reset.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                },
              ),
            );
          },
        ),

        const const SizedBox(height: AmagamaSpacing.md),

        // ------------------------------------------------------------
        // PARENTAL CONTROLS
        // ------------------------------------------------------------
        const SettingsSectionHeader(title: 'Parental controls'),

        SettingsTile(
          icon: Icons.lock_reset_rounded,
          label: 'Change parental PIN',
          color: AmagamaColors.secondary,
          onTap: () async {
            final existing = await pinService.loadPin();

            // 1️⃣ VERIFY EXISTING PIN (if present)
            if (existing != null) {
              final ok = await _verifyPin(context, existing);
              if (!ok) return;
            }

            // 2️⃣ CREATE / UPDATE PIN
            final newPin =
                await _createPin(context, existing == null);
            if (newPin == null) return;

            await pinService.savePin(newPin);
            await pinService.resetAttempts();

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const const SnackBar(
                content: const Text('Parental PIN updated.'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ],
    );
  }
}