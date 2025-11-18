// 📄 lib/screens/settings_screen.dart
// ⚙️ Settings Screen

import 'package:flutter/material.dart';
import '../widgets/common/screen_header.dart';
import '../widgets/settings/settings_content.dart';
import '../theme/index.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Settings',
              showLogo: false,
              leadingAction: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Expanded(child: SettingsContent()),
          ],
        ),
      ),
    );
  }
}