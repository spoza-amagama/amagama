// 📄 lib/theme/theme.dart
//
// African-inspired Material Theme for Amagama.
// Uses earthy warmth, golden accents, and vibrant greens.

import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

class AmagamaTheme {
  static ThemeData light() {
    final base = ThemeData.light();

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AmagamaColors.primary,
        secondary: AmagamaColors.secondary,
        surface: AmagamaColors.surface,
      ),
      scaffoldBackgroundColor: AmagamaColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AmagamaColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AmagamaColors.secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AmagamaSpacing.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AmagamaSpacing.lg,
            vertical: AmagamaSpacing.sm,
          ),
        ),
      ),
      textTheme: AmagamaTypography.textTheme,
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AmagamaColors.secondary,
        secondary: AmagamaColors.primary,
        surface: const Color(0xFF1C1917),
      ),
      textTheme: AmagamaTypography.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}
