// 📄 lib/widgets/grownups/pin_subtitle.dart
//
// 📝 PinSubtitle — supporting text for the parental PIN dialog.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinSubtitle extends StatelessWidget {
  final bool hasPin;

  const PinSubtitle({
    super.key,
    required this.hasPin,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      hasPin
          ? 'This area is for grown\nups only.'
          : 'Choose a 4-digit PIN\nfor parent access.',
      textAlign: TextAlign.center,
      style: AmagamaTypography.bodyStyle.copyWith(
        fontSize: 18,
        color: AmagamaColors.textSecondary,
      ),
    );
  }
}