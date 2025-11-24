// 📄 lib/utils/grownups_guard.dart
//
// GrownUpsGuard — central handler for accessing the Grown Ups screen.
// ------------------------------------------------------------
// • If PIN exists → verify
// • Otherwise → create
// • Uses new PinService API (no lockout / attempts).
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/routes/index.dart';
import 'package:amagama/services/pin_service.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_entry_flow.dart';

class GrownUpsGuard {
  final PinService _pin = PinService();

  Future<void> open(BuildContext context) async {
    // Make sure service has loaded the stored PIN.
    await _pin.init();

    final existingPin = _pin.currentPin;

    if (existingPin == null) {
      // -------------------------
      // CREATE PIN
      // -------------------------
      final created = await PinEntryFlow.showCreate(
        context: context,
        title: 'Create\nParent PIN',
      );
      if (created == null) return;

      await _pin.setPin(created);
      if (!context.mounted) return;
      Navigator.pushNamed(context, AppRoutes.grownups);
    } else {
      // -------------------------
      // VERIFY PIN
      // -------------------------
      final verified = await PinEntryFlow.showVerify(
        context: context,
        title: 'Enter\nParent PIN',
        correctPin: existingPin,
      );
      if (verified == null) return;

      if (!context.mounted) return;
      Navigator.pushNamed(context, AppRoutes.grownups);
    }
  }
}