// 📄 lib/widgets/home/actions/grownups_button.dart
//
// GrownUpsButton — entry to parental controls via GrownUpsGuard.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/utils/grownups_guard.dart';

class GrownUpsButton extends StatelessWidget {
  const GrownUpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor:
              WidgetStateProperty.all<Color>(AmagamaColors.textPrimary),
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 16),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
        onPressed: () async {
          final guard = GrownUpsGuard();
          await guard.open(context);
        },
        child: const Text(
          'Grown Ups',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
