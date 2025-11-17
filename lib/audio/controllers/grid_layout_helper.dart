// 📄 lib/controllers/grid_layout_helper.dart
//
// 🧮 GridLayoutHelper
// ----------------------
// Provides a single, pure function [computeLayout] that calculates
// the optimal number of columns, rows, and card sizes for the play grid
// based on available screen dimensions and total cards.
// Used by [CardGrid] to maintain consistent, adaptive layout.

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Struct-like model describing computed grid layout parameters.
class GridLayout {
  final int cols;
  final int rows;
  final double cardSize;
  final double spacing;
  final double topPadding;

  const GridLayout({
    required this.cols,
    required this.rows,
    required this.cardSize,
    required this.spacing,
    required this.topPadding,
  });
}

/// Calculates best-fit layout for card grid.
///
/// - Dynamically adapts to screen width/height.
/// - Ensures cards are evenly spaced and centered vertically.
/// - Returns a [GridLayout] object with layout data.
GridLayout computeLayout({
  required Size boxSize,
  required int totalCards,
}) {
  final width = boxSize.width;
  final height = boxSize.height;

  // Base spacing logic (scales with screen width)
  final baseSpacing = width < 400
      ? 8.0
      : width < 600
          ? 10.0
          : 14.0;

  int bestCols = 2;
  int bestRows = (totalCards / bestCols).ceil();
  double bestCardSize = 0;

  // Try multiple column counts and pick the best fit
  for (int cols = 2; cols <= totalCards; cols++) {
    final rows = (totalCards / cols).ceil();
    final totalHSpacing = (cols - 1) * baseSpacing;
    final totalVSpacing = (rows - 1) * baseSpacing;
    final availableWidth = width - totalHSpacing - 16;
    final availableHeight = height - totalVSpacing - 16;
    if (availableWidth <= 0 || availableHeight <= 0) continue;

    final size = math
        .min(availableWidth / cols, availableHeight / rows)
        .clamp(40.0, 160.0);
    if (cols * rows >= totalCards && size > bestCardSize) {
      bestCardSize = size;
      bestCols = cols;
      bestRows = rows;
    }
  }

  final usedHeight = bestRows * bestCardSize + (bestRows - 1) * baseSpacing;
  final topPadding = ((height - usedHeight) / 2).clamp(0.0, double.infinity);

  return GridLayout(
    cols: bestCols,
    rows: bestRows,
    cardSize: bestCardSize,
    spacing: baseSpacing,
    topPadding: topPadding,
  );
}