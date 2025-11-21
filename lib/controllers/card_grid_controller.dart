// 📄 lib/controllers/card_grid_controller.dart
//
// CardGridController — layout + card state manager for the play grid.

import 'dart:math';
import 'package:flutter/material.dart';

class GridLayout {
  final int cols;
  final double spacing;
  final double topPadding;
  final Size cardSize;
  final bool scrollable;

  const GridLayout({
    required this.cols,
    required this.spacing,
    required this.topPadding,
    required this.cardSize,
    required this.scrollable,
  });
}

class CardGridController extends ChangeNotifier {
  final Set<String> _matched = {};
  final Set<String> _glowing = {};

  // ------------------------------------------------------------
  // MATCH / GLOW STATE
  // ------------------------------------------------------------

  bool isMatched(String id) => _matched.contains(id);
  bool isGlowing(String id) => _glowing.contains(id);

  void setMatched(String id) {
    _matched.add(id);
    notifyListeners();
  }

  void clearGlows() {
    _glowing.clear();
    notifyListeners();
  }

  void glow(String id) {
    _glowing.add(id);
    notifyListeners();
  }

  void reset() {
    _matched.clear();
    _glowing.clear();
    notifyListeners();
  }

  // ------------------------------------------------------------
  // GRID LAYOUT
  // ------------------------------------------------------------

  GridLayout computeGridLayout({
    required Size boxSize,
    required int totalCards,
  }) {
    const spacing = 10.0;

    // Estimate columns (square-ish grid)
    int cols = max(2, (sqrt(totalCards)).round());

    // Card size calculation
    double w = (boxSize.width - (cols - 1) * spacing) / cols;
    double h = w; // square

    final cardSize = Size(w, h);

    final rows = (totalCards / cols).ceil();
    final totalHeight = rows * h + (rows - 1) * spacing;

    final scrollable = totalHeight > boxSize.height;
    final topPadding = scrollable ? 0.0 : (boxSize.height - totalHeight) / 2;

    return GridLayout(
      cols: cols,
      spacing: spacing,
      cardSize: cardSize,
      topPadding: topPadding,
      scrollable: scrollable,
    );
  }
}