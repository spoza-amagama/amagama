// 📄 lib/utils/grid_layout_helper.dart
// ------------------------------------------------------------
// 🧮 computeAdaptiveLayout
// Pure function: returns card size/spacing/topPad/cols
// for an adaptive single-screen centered grid (2–7 cols).
// ------------------------------------------------------------

import 'package:flutter/material.dart';

class GridLayout {
  final double cardSize;
  final double spacing;
  final double topPad;
  final int cols;

  const GridLayout({
    required this.cardSize,
    required this.spacing,
    required this.topPad,
    required this.cols,
  });
}

GridLayout computeAdaptiveLayout({
  required Size size,
  required int total,
  required bool isTablet,
}) {
  final w = size.width;
  final h = size.height;

  final spacing = isTablet
      ? (w > 1000 ? 20.0 : 14.0)
      : (w < 420 ? 8.0 : 10.0);

  const minCard = 56.0;
  const maxCard = 220.0;

  double bestCard = minCard;
  int bestCols = 2;
  double bestTopPad = 0.0;

  final maxCols = isTablet ? 7 : total.clamp(2, 5);

  for (int cols = 2; cols <= maxCols && cols <= total; cols++) {
    final rows = (total / cols).ceil();
    final usableW = w - (cols - 1) * spacing - 16;
    final usableH = h - (rows - 1) * spacing - 16;
    if (usableW <= 0 || usableH <= 0) continue;

    final cellW = usableW / cols;
    final cellH = usableH / rows;
    final card = (cellW < cellH ? cellW : cellH).clamp(minCard, maxCard);

    final totalGridHeight = rows * card + (rows - 1) * spacing;
    if (totalGridHeight > h) continue;

    final topPad = ((h - totalGridHeight) / 2).clamp(0.0, double.infinity);

    final better = (card > bestCard) ||
        (card == bestCard && rows < (total / bestCols).ceil());

    if (better) {
      bestCard = card.toDouble();
      bestCols = cols;
      bestTopPad = topPad;
    }
  }

  return GridLayout(
    cardSize: bestCard,
    spacing: spacing,
    topPad: bestTopPad,
    cols: bestCols,
  );
}
