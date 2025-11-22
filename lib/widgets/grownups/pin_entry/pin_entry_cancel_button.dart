// 📄 lib/widgets/grownups/pin_entry/pin_entry_cancel_button.dart
// PinEntryCancelButton — standard Cancel button for PIN dialogs.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class PinEntryCancelButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PinEntryCancelButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Cancel',
        style: AmagamaTypography.bodyStyle.copyWith(
          color: AmagamaColors.accent,
        ),
      ),
    );
  }
}
