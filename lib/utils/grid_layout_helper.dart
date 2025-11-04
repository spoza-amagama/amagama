// 📂 lib/utils/grid_layout_helper.dart
import 'package:flutter/material.dart';

/// 🧮 GridLayoutHelper
/// ------------------------------------------------------
/// Calculates responsive grid layout parameters so that
/// cards always fit neatly within one screen across phones
/// and tablets, portrait or landscape.
class GridLayout {
  final int crossAxisCount;
  final double aspectRatio;
  final double cardWidth;
  final double cardHeight;
  final double spacing;
  final double padding;
  final bool isTablet;
  final bool isLandscape;

  const GridLayout({
    required this.crossAxisCount,
    required this.aspectRatio,
    required this.cardWidth,
    required this.cardHeight,
    required this.isTablet,
    required this.isLandscape,
    this.spacing = 12.0,
    this.padding = 16.0,
  });
}

class GridLayoutHelper {
  /// Calculates layout for a given screen and number of cards.
  static GridLayout calculate(BuildContext context, int totalCards) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    final isLandscape = orientation == Orientation.landscape;
    final isTablet = _isTablet(size);

    // 🧱 Base constants
    const padding = 16.0;
    const spacing = 12.0;

    // 🧩 Column logic
    int crossAxisCount;
    if (isTablet) {
      crossAxisCount = isLandscape ? 4 : 3;
    } else {
      crossAxisCount = totalCards <= 6 ? 2 : 3;
      if (isLandscape && totalCards > 6) crossAxisCount = 4;
    }

    final rows = (totalCards / crossAxisCount).ceil();

    // 📏 Available height (subtracts app bar + text area)
    final availableHeight =
        size.height - (rows - 1) * spacing - padding * 2 - kToolbarHeight - 160;

    final cardHeight = availableHeight / rows;
    final cardWidth =
        (size.width - (padding * 2) - (crossAxisCount - 1) * spacing) /
            crossAxisCount;

    // ⚙️ Slightly wider cards on tablets for larger avatars
    final aspectRatio = (cardWidth / cardHeight).clamp(
      isTablet ? 0.9 : 0.8,
      isTablet ? 1.3 : 1.2,
    );

    return GridLayout(
      crossAxisCount: crossAxisCount,
      aspectRatio: aspectRatio,
      cardWidth: cardWidth,
      cardHeight: cardHeight,
      isTablet: isTablet,
      isLandscape: isLandscape,
      spacing: spacing,
      padding: padding,
    );
  }

  /// 🧠 Determines if screen is a tablet based on shortest side
  static bool _isTablet(Size size) {
    final shortestSide = size.shortestSide;
    return shortestSide > 600; // standard breakpoint
  }
}
