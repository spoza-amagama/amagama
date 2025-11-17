// 📄 lib/theme/amagama_buttons.dart

import 'package:flutter/material.dart';
import 'colors.dart';
import 'spacing.dart';

class AmagamaButtons {
  AmagamaButtons._();

  static final ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AmagamaColors.primary,
    foregroundColor: AmagamaColors.textPrimary, // ← FIXED
    padding: const EdgeInsets.symmetric(
      horizontal: AmagamaSpacing.lg,
      vertical: AmagamaSpacing.sm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AmagamaSpacing.radiusMd),
    ),
  );

  static final ButtonStyle secondary = ElevatedButton.styleFrom(
    backgroundColor: AmagamaColors.secondary,
    foregroundColor: AmagamaColors.textPrimary, // ← FIXED
    padding: const EdgeInsets.symmetric(
      horizontal: AmagamaSpacing.lg,
      vertical: AmagamaSpacing.sm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AmagamaSpacing.radiusMd),
    ),
  );
}