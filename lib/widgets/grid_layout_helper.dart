// 📄 lib/widgets/grid_layout_helper.dart
//
// 🧮 GridLayoutHelper
// ------------------------------------------------------------
// Pure utility for calculating responsive grid layout for
// match cards across devices & orientations.
//
// GOALS
// • Predictable spacing and sizing
// • No magic numbers — uses AmagamaSpacing
// • Supports circle cards (square aspect ratio)
// • Centers grid vertically
//
// USED BY
// • AnimatedMatchGrid
//

import 'package:amagama/theme/index.dart';

class GridLayoutHelper {
  final int cols;
  final double spacing;
  final double cardSize;
  final double topPadding;

  const GridLayoutHelper({
    required this.cols,
    required this.spacing,
    required this.cardSize,
    required this.topPadding,
  });

  /// Calculate best layout based on available width/height.
  /// TotalCards is typically 6, 8, 10 or 12.
  static GridLayoutHelper calculate({
    required double width,
    required double height,
    required int totalCards,
  }) {
    // ------------------------------------------------------------
    // SPACING
    // ------------------------------------------------------------
    final spacing = width < 360
        ? AmagamaSpacing.xs
        : width < 500
            ? AmagamaSpacing.sm
            : AmagamaSpacing.md;

    // ------------------------------------------------------------
    // DETERMINE COLUMNS BY CARD COUNT
    // (Predictable, not brute-forced)
    // ------------------------------------------------------------
    int cols;
    if (totalCards <= 6) {
      cols = 2;
    } else if (totalCards <= 10) {
      cols = 3;
    } else {
      cols = 4;
    }

    final rows = (totalCards / cols).ceil();

    // ------------------------------------------------------------
    // CARD SIZE CALCULATION
    // ------------------------------------------------------------
    final totalHorizontalSpacing = (cols - 1) * spacing;
    final totalVerticalSpacing = (rows - 1) * spacing;

    final availableWidth = width - totalHorizontalSpacing - AmagamaSpacing.md;
    final availableHeight = height - totalVerticalSpacing - AmagamaSpacing.lg;

    // Maximum square size allowed
    final cardSize = [
      availableWidth / cols,
      availableHeight / rows,
      160.0,
    ].reduce((a, b) => a < b ? a : b).clamp(56.0, 160.0);

    // ------------------------------------------------------------
    // VERTICAL CENTERING
    // ------------------------------------------------------------
    final usedHeight = rows * cardSize + totalVerticalSpacing;
    final topPadding = ((height - usedHeight) / 2).clamp(0.0, 80.0);

    return GridLayoutHelper(
      cols: cols,
      spacing: spacing,
      cardSize: cardSize,
      topPadding: topPadding,
    );
  }
}