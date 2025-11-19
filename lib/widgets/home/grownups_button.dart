// 📄 lib/widgets/home/grownups_button.dart
//
// 🔒 GrownUpsButton — entry to parental controls with themed styling.

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/widgets/grownups/grownup_pin_dialog.dart';

class GrownUpsButton extends StatelessWidget {
  const GrownUpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => const GrownupPinDialog(),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AmagamaColors.surface.withValues(alpha: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: AmagamaColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                'Grown ups',
                style: AmagamaTypography.bodyStyle.copyWith(
                  color: AmagamaColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}