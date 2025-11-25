// 📄 lib/screens/settings_screen.dart
//
// ⚙️ Settings Screen — unified header
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/common/index.dart';
import 'package:amagama/widgets/settings/settings_content.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AmagamaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(title: "Settings"),
            Expanded(child: SettingsContent()),
          ],
        ),
      ),
    );
  }
}