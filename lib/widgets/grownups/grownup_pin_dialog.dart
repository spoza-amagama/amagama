// 📄 lib/widgets/grownups/grownup_pin_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amagama/state/game_controller.dart';
import 'pin_entry_flow.dart';
import 'grownup_menu_dialog.dart';

class GrownupPinDialog extends StatelessWidget {
  const GrownupPinDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final pinSvc = context.watch<GameController>().pin;

    final hasPin = pinSvc.currentPin != null;

    return PinEntryFlow(
      title: hasPin ? "Enter PIN" : "Create PIN",
      verifyAgainst: hasPin ? pinSvc.currentPin : null,
      enforceLengthOnly: !hasPin,
      onComplete: (pin) {
        if (!hasPin) pinSvc.setPin(pin);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const GrownupMenuDialog(),
        );
      },
    );
  }
}