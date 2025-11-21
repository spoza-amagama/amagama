// 📄 lib/screens/settings_screen.dart
// ⚙️ Settings Screen — unified with Amagama theme + header patterns.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/settings/settings_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ------------------------------------------------------------
            // Header (matches Home/Play/Grownups style)
            // ------------------------------------------------------------
            ScreenHeader(
              title: 'Settings',
              showLogo: false,
              leadingAction: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: AmagamaColors.textPrimary,
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ------------------------------------------------------------
            // Content
            // ------------------------------------------------------------
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SettingsContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}