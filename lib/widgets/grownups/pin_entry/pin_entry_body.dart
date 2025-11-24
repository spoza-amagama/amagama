// 📄 lib/widgets/grownups/pin_entry/pin_entry_body.dart
//
// PinEntryBody — pure UI for the PIN entry dialog.
// ------------------------------------------------------------
// • Title
// • PIN dots
// • Responsive keypad
// • Optional "Forgot PIN?" link
// • Cancel button (delegated via callback)

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_dots.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_keypad.dart';

class PinEntryBody extends StatelessWidget {
  final String title;
  final int filled;
  final void Function(String) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onCancel;

  final bool showForgotPin;
  final VoidCallback? onForgotPin;

  const PinEntryBody({
    super.key,
    required this.title,
    required this.filled,
    required this.onDigit,
    required this.onBackspace,
    required this.onCancel,
    this.showForgotPin = false,
    this.onForgotPin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      decoration: BoxDecoration(
        color: AmagamaColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AmagamaTypography.titleStyle.copyWith(
              fontSize: 26,
              color: AmagamaColors.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          // PIN dots
          PinDots(filled: filled),

          const SizedBox(height: 28),

          // Keypad
          PinKeypad(
           onDigit: onDigit,        // FIXED
          onBackspace: onBackspace,
),

          const SizedBox(height: 8),

          // Optional "Forgot PIN?"
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

          const SizedBox(height: 8),

          // Cancel
          TextButton(
            onPressed: onCancel,
            child: Text(
              'Cancel',
              style: AmagamaTypography.bodyStyle.copyWith(
                color: AmagamaColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}