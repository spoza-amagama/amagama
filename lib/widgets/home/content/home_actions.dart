// 📄 lib/widgets/home/content/home_actions.dart
//
// HomeActions — Play + Grown Ups button row for the Home screen.
// --------------------------------------------------------------
// • Play button -> navigates to gameplay
// • Grown Ups button -> PIN-protected via GrownUpsGate
// --------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/routes/index.dart';
import 'package:amagama/widgets/grownups/grownups_gate.dart';

class HomeActions extends StatelessWidget {
  const HomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --------------------------------------------------------
        // PLAY BUTTON
        // --------------------------------------------------------
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(AmagamaColors.primary),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 16),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.play);
            },
            child: const Text(
              'Play',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: AmagamaSpacing.lg),

        // --------------------------------------------------------
        // GROWN UPS BUTTON
        // --------------------------------------------------------
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              foregroundColor: WidgetStateProperty.all<Color>(AmagamaColors.textPrimary),
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
              await GrownUpsGate.open(context);
            },
            child: const Text(
              'Grown Ups',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}