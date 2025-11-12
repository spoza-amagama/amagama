// 📄 lib/theme/typography.dart
//
// Typography inspired by African print design — rounded, friendly,
// readable for children, but expressive and rhythmic.

import 'package:flutter/material.dart';
import 'colors.dart';

class AmagamaTypography {
  static const _fontFamily = 'Nunito'; // friendly rounded font

  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 34,
      fontWeight: FontWeight.w800,
      color: AmagamaColors.textPrimary,
      letterSpacing: 0.5,
    ),
    headlineSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AmagamaColors.textPrimary,
      letterSpacing: 0.25,
    ),
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AmagamaColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AmagamaColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AmagamaColors.textPrimary,
    ),
  );
}
