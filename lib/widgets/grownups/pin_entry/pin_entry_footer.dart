// 📄 lib/widgets/grownups/pin_entry/pin_entry_footer.dart
//
// PinEntryFooter — "Forgot PIN?" + "Cancel" actions for PIN dialog.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinEntryFooter extends StatelessWidget {
  final bool showForgotPin;
  final VoidCallback? onForgotPin;

  const PinEntryFooter({
    super.key,
    required this.showForgotPin,
    this.onForgotPin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showForgotPin && onForgotPin != null)
          TextButton(
            onPressed: onForgotPin,
            child: Text(
              'Forgot PIN?',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.accent,
              ),
            ),
          ),

        const const SizedBox(height: 8),

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AmagamaTypography.bodyStyle.copyWith(
              color: AmagamaColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}