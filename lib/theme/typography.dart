// 📄 lib/theme/typography.dart
//
// Typography inspired by African print design — rounded, friendly,
// readable for children, but expressive and rhythmic.
// ------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'colors.dart';

class AmagamaTypography {
  static const _fontFamily = 'Nunito'; // Friendly rounded font

  // ------------------------------------------------------------
  // DEFAULT TEXT THEME
  // ------------------------------------------------------------
  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 34,
      fontWeight: FontWeight.w800,
      color: AmagamaColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AmagamaColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AmagamaColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AmagamaColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AmagamaColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AmagamaColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AmagamaColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AmagamaColors.textSecondary,
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

  // ------------------------------------------------------------
  // APP-WIDE CUSTOM TEXT STYLES
  // ------------------------------------------------------------

  /// Large screen titles (Home screen, major headers)
  static const TextStyle titleStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AmagamaColors.textPrimary,
  );

  /// Medium section headers (game titles, lesson sections)
  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AmagamaColors.textPrimary,
  );

  /// Subtitles / instructional text
  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AmagamaColors.textSecondary,
  );

  /// Standard body text
  static const TextStyle bodyStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AmagamaColors.textPrimary,
  );

  /// Small supporting text
  static const TextStyle smallLabelStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AmagamaColors.textSecondary,
  );

  /// Word cards + flashcards (primary learning content)
  static const TextStyle wordCardStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AmagamaColors.textPrimary,
  );

  /// Buttons across the app
  static const TextStyle buttonStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AmagamaColors.textPrimary,
  );

  /// Score numbers on play screens
  static const TextStyle scoreStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: AmagamaColors.textPrimary,
  );

/// Progress text (cycles / sentence counts)
static const TextStyle progressStyle = TextStyle(
  fontFamily: _fontFamily,
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: AmagamaColors.textSecondary,
);

  /// Progress badges / week number tags
  static const TextStyle badgeStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AmagamaColors.textPrimary,
  );
}