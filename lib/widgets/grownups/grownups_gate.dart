// 📄 lib/widgets/grownups/grownups_gate.dart
//
// GrownupsGate — central access controller for the parental area.
// --------------------------------------------------------------
// • Checks if PIN exists
// • If no PIN → require creation
// • If PIN exists → require verification
// • Handles lockout state
// • Uses PinService and GrownupsPinDialog
// --------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/services/pin_service.dart';
import 'package:amagama/widgets/grownups/grownups_pin_dialog.dart';

class GrownupsGate {
  static Future<bool> requestAccess(BuildContext context) async {
    final pin = PinService();

    // 🔐 Is locked out?
    if (await pin.isLockedOut()) {
      await showDialog(
        context: context,
        builder: (_) => const _LockedOutDialog(),
      );
      return false;
    }

    // 📌 No PIN yet → create one
    final savedPin = await pin.loadPin();
    if (savedPin == null) {
      final newPin = await GrownupsPinDialog.showCreate(context);
      if (newPin == null) return false; // cancelled

      await pin.savePin(newPin);
      await pin.resetAttempts();
      return true;
    }

    // 🔎 Verify PIN
    final result = await GrownupsPinDialog.showVerify(context, savedPin);

    if (result == null) {
      return false; // user cancelled
    }

    final success = result == savedPin;

    if (!success) {
      await pin.registerFail();
      return false;
    }

    await pin.resetAttempts();
    return true;
  }
}

class _LockedOutDialog extends StatelessWidget {
  const _LockedOutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Locked Out"),
      content: const Text(
        "Too many attempts. Try again in a little while.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        )
      ],
    );
  }
}
