// 📄 lib/widgets/settings/settings_content.dart
//
// ⚙️ SettingsContent — unified settings screen with direct access
// to Grown-ups PIN via GrownupPinDialog.
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/grownups/settings_tile.dart';
import 'package:amagama/widgets/grownups/grownup_pin_dialog.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: AmagamaSpacing.md,
        horizontal: AmagamaSpacing.sm,
      ),
      children: [
        // ───────────────────────────────────────────────
        // Sound Settings — placeholder
        // ───────────────────────────────────────────────
        SettingsTile(
          icon: Icons.volume_up_rounded,
          label: 'Sound settings',
          color: AmagamaColors.secondary,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sound settings coming soon")),
            );
          },
        ),

        const SizedBox(height: 12),

        // ───────────────────────────────────────────────
        // Parental Controls → Grown-ups PIN
        // ───────────────────────────────────────────────
        SettingsTile(
          icon: Icons.lock_rounded,
          label: 'Grown-ups PIN',
          color: AmagamaColors.primary,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const GrownupPinDialog(),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}