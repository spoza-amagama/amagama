// 📄 lib/widgets/settings/settings_content.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AmagamaSpacing.md),
      children: const [
        ListTile(
          leading: Icon(Icons.volume_up),
          title: Text('Sound'),
          subtitle: Text('Configure game audio (coming soon)'),
        ),
        SizedBox(height: AmagamaSpacing.sm),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Parental controls'),
          subtitle: Text('Grown Ups PIN and rules (coming soon)'),
        ),
      ],
    );
  }
}