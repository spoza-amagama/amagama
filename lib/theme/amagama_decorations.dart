// 📄 lib/theme/amagama_decorations.dart
//
// 🎨 Centralized reusable BoxDecoration builders for Amagama.
// Keeps HomeScreen and other widgets clean + consistent.
// --------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'index.dart';

class AmagamaDecorations {
  /// Gradient + shadow app bar background
  static BoxDecoration appBar() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AmagamaColors.primary,
          AmagamaColors.secondary.withValues(alpha: 0.85),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: AmagamaColors.primary.withValues(alpha: 0.25),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  /// Rounded content card background
  static BoxDecoration contentCard() {
    return BoxDecoration(
      color: AmagamaColors.background.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(AmagamaSpacing.radiusLg),
      boxShadow: [
        BoxShadow(
          color: AmagamaColors.secondary.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}