// 📄 lib/widgets/grownups/pin_entry/pin_entry_title.dart
// PinEntryTitle — heading text for PIN dialogs.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinEntryTitle extends StatelessWidget {
  final String title;

  const PinEntryTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: AmagamaTypography.titleStyle.copyWith(
        fontSize: 26,
        color: AmagamaColors.textPrimary,
      ),
    );
  }
}
