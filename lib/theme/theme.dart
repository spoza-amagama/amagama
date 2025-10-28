import 'package:flutter/material.dart';

ThemeData buildTheme({Brightness brightness = Brightness.light}) {
  const fontFamily = 'NunitoKids';
  final isDark = brightness == Brightness.dark;

  final primaryColor =
      isDark ? const Color(0xFFFFD54F) : const Color(0xFFFFC107);
  final backgroundColor =
      isDark ? const Color(0xFF303030) : const Color(0xFFFFF8E1);
  final surfaceColor = isDark ? const Color(0xFF424242) : Colors.white;
  final textColor = isDark ? Colors.white : Colors.black87;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: fontFamily,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textColor,
      centerTitle: true,
      elevation: 2,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),

    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: isDark ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),

    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w800,
        fontSize: 24,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        color: textColor,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return primaryColor.withValues(alpha: 0.8); // darker on press
            }
            return primaryColor;
          },
        ),
        foregroundColor: WidgetStateProperty.all<Color>(textColor),
        elevation: WidgetStateProperty.resolveWith<double>(
          (states) {
            if (states.contains(WidgetState.pressed)) return 1;
            if (states.contains(WidgetState.hovered)) return 6;
            return 3;
          },
        ),
        overlayColor: WidgetStateProperty.all<Color>(
          Colors.black12, // subtle tap ripple
        ),
        shadowColor: WidgetStateProperty.all<Color>(
          isDark ? Colors.black54 : Colors.grey.withValues(alpha: 0.4),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        animationDuration: const Duration(milliseconds: 120),
      ),
    ),

    // Gentle ink splash feedback for all interactive surfaces
    splashFactory: InkRipple.splashFactory,
  );
}
