// 📄 lib/widgets/settings/settings_content.dart
//
// SettingsContent — application settings screen.
// ------------------------------------------------------------
// • Reset all progress
// • Adjust cycles per sentence
// • Change parental PIN (verify then create)
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

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AmagamaSpacing.md,
        vertical: AmagamaSpacing.md,
      ),
      children: [
        const SettingsSectionHeader(title: 'Gameplay'),

        SettingsTile(
          icon: Icons.repeat_rounded,
          label: 'Cycles per sentence',
          color: AmagamaColors.primary,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cyclesSettings);
          },
        ),

        const SizedBox(height: AmagamaSpacing.md),

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

        const SizedBox(height: AmagamaSpacing.md),

        const SettingsSectionHeader(title: 'Parental controls'),

        SettingsTile(
          icon: Icons.lock_reset_rounded,
          label: 'Change parental PIN',
          color: AmagamaColors.secondary,
          onTap: () async {
            final pinService = PinService();
            await pinService.init();
            final existingPin = pinService.currentPin;

            // ------------------------------------------------
            // 1. Verify current PIN (if set)
            // ------------------------------------------------
            if (existingPin != null) {
              final verified = await PinEntryFlow.showVerify(
                context: context,
                title: 'Enter current PIN',
                correctPin: existingPin,
              );
              if (verified == null) return;
            }

            // ------------------------------------------------
            // 2. Create new PIN
            // ------------------------------------------------
            final newPin = await PinEntryFlow.showCreate(
              context: context,
              title:
                  existingPin == null ? 'Create new PIN' : 'Enter new PIN',
            );
            if (newPin == null) return;

            await pinService.setPin(newPin);

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Parental PIN updated.'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ],
    );
  }
}