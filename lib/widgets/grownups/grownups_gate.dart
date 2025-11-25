// 📄 lib/widgets/grownups/grownups_gate.dart
//
// GrownUpsGate — helper to open the Grown Ups area behind a PIN,
// now using a slide-up + fade route.

import 'package:flutter/material.dart';
import 'package:amagama/routes/index.dart';
import 'package:amagama/services/pin_service.dart';
import 'package:amagama/widgets/grownups/pin_entry/pin_entry_flow.dart';

class GrownUpsGate {
  static Future<void> open(BuildContext context) async {
    final pinService = PinService();
    await pinService.init();

    final existingPin = pinService.currentPin;

    if (existingPin == null) {
      // No PIN yet → create one
      final created = await PinEntryFlow.showCreate(
        context: context,
        title: 'Create\nParent PIN',
      );
      if (created == null) return;

      await pinService.setPin(created);
      if (!context.mounted) return;

      Navigator.of(context).push(createGrownUpsRoute());
    } else {
      // PIN exists → verify
      final verified = await PinEntryFlow.showVerify(
        context: context,
        title: 'Enter\nParent PIN',
        correctPin: existingPin,
      );
      if (verified == null) return;

      if (!context.mounted) return;

      Navigator.of(context).push(createGrownUpsRoute());
    }
  }
}