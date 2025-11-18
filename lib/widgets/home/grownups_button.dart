// 📄 lib/widgets/home/grownups_button.dart

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/grownups/grownup_pin_dialog.dart';
import 'package:amagama/routes/index.dart';

class GrownUpsButton extends StatelessWidget {
  const GrownUpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: AmagamaColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      onPressed: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => const GrownUpPinDialog(),
        );
        if (ok == true) {
          Navigator.pushNamed(context, AppRoutes.grownups);
        }
      },
      child: Text(
        "Grown Ups",
        style: AmagamaTypography.buttonStyle
            .copyWith(color: AmagamaColors.textPrimary),
      ),
    );
  }
}