// 📄 lib/widgets/grownups/grownups_pin_dialog.dart
//
// GrownupsPinDialog — wrapper around PinEntryFlow
// --------------------------------------------------------------
// • showCreate()  → creates new parental PIN
// • showVerify()  → verifies existing PIN
// • Returns the PIN on success, null on cancel
// --------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_entry_flow.dart';

class GrownupsPinDialog {
  /// Create a new 4-digit PIN.
  static Future<String?> showCreate(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PinEntryFlow(
        title: "Create Parental PIN",
        enforceLengthOnly: true,
        onComplete: (pin) {
          Navigator.pop(context, pin);
        },
      ),
    );
  }

  /// Verify the existing parental PIN.
  static Future<String?> showVerify(
    BuildContext context,
    String correctPin,
  ) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PinEntryFlow(
        title: "Enter Parental PIN",
        verifyAgainst: correctPin,
        onComplete: (pin) {
          Navigator.pop(context, pin);
        },
      ),
    );
  }
}
