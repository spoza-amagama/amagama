// 📄 lib/utils/grownups_guard.dart
//
// GrownUpsGuard — central handler for accessing the Grown Ups screen.
// ------------------------------------------------------------
// • If PIN exists → verify
// • Otherwise → create
// • Uses PinService + PinEntryFlow
// • Now navigates with a slide-up + fade transition
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/routes/index.dart'; // must export grownups_route.dart
import 'package:amagama/services/pin_service.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_entry_flow.dart';

class GrownUpsGuard {
  final PinService _pin = PinService();

  Future<void> open(BuildContext context) async {
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

      // 🔥 Custom animated transition into Grown Ups
      Navigator.of(context).push(createGrownUpsRoute());
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

      // 🔥 Custom animated transition into Grown Ups
      Navigator.of(context).push(createGrownUpsRoute());
    }
  }
}