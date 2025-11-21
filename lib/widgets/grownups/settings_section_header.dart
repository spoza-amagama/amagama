// 📄 lib/widgets/grownups/settings_section_header.dart
//
// SettingsSectionHeader — simple section label for Grown Ups Screen.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AmagamaSpacing.sm,
        horizontal: AmagamaSpacing.md,
      ),
      child: Text(
        title,
        style: AmagamaTypography.titleStyle.copyWith(
          fontSize: 18,
          color: AmagamaColors.textSecondary,
        ),
      ),
    );
  }
}