// 📄 lib/widgets/grownups/pin_title.dart
//
// 📛 PinTitle — title text for the parental PIN dialog.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinTitle extends StatelessWidget {
  final bool hasPin;

  const PinTitle({
    super.key,
    required this.hasPin,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      hasPin ? 'Enter Parental\nPIN' : 'Create Parental\nPIN',
      textAlign: TextAlign.center,
      style: AmagamaTypography.titleStyle.copyWith(
        fontSize: 32,
        color: AmagamaColors.textPrimary,
      ),
    );
  }
}