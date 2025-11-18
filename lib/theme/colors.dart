// 📄 lib/theme/colors.dart
//
// Defines Amagama’s African-inspired color palette,
// evoking natural tones of earth, sun, and foliage.

import 'package:flutter/material.dart';

class AmagamaColors {
  // Vibrant primaries — inspired by African landscapes
  static const primary = Color(0xFFD97706); // warm amber (sunlight)
  static const secondary = Color(0xFF047857); // deep green (foliage)
  static const accent = Color(0xFFB91C1C); // rich red (earth/clay)

  // Backgrounds — warm neutrals
  static const surface = Color(0xFFFAF7F0); // light sand (cards / panels)

  // 🌅 Soft orange wash for main screen background
  static const background = Color(0xFFF8C27A); // soft amber backdrop

  // Text
  static const textPrimary = Color(0xFF2C1810); // dark cocoa
  static const textSecondary = Color(0xFF6B4F3B); // muted brown

  // States
  static const success = Color(0xFF16A34A); // natural green
  static const error = Color(0xFFDC2626); // clay red
  static const warning = Color(0xFFEAB308); // gold

  // Shadows / overlays
  static Color overlay(double alpha) =>
      const Color(0xFF000000).withValues(alpha: alpha);
}