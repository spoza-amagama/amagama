// 📄 lib/widgets/grownups/pin_entry/pin_entry_forgot_button.dart
// PinEntryForgotButton — optional “Forgot PIN?” link.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinEntryForgotButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PinEntryForgotButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Forgot PIN?',
        style: AmagamaTypography.bodyStyle.copyWith(
          color: AmagamaColors.accent,
        ),
      ),
    );
  }
}
