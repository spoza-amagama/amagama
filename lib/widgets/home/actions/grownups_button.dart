// 📄 lib/widgets/home/actions/grownups_button.dart
//
// 🔒 GrownUpsButton — entry to parental controls via GrownUpsGuard.
// ------------------------------------------------------------
// • Uses GrownUpsGuard to trigger PIN create/verify flow
// • Centered lock icon + label inside pill
//

import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';
import 'package:amagama/utils/grownups_guard.dart';

class GrownUpsButton extends StatelessWidget {
  const GrownUpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          final guard = GrownUpsGuard();
          await guard.open(context);
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
          alignment: Alignment.center, // ✅ center contents in pill
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: AmagamaColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                'Grown Ups',
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