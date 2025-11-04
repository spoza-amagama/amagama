// lib/widgets/grid_layout_helper.dart
class GridLayoutHelper {
  final int cols;
  final double spacing;
  final double cardSize;
  final double topPadding;

  GridLayoutHelper({
    required this.cols,
    required this.spacing,
    required this.cardSize,
    required this.topPadding,
  });

  static GridLayoutHelper calculate(
      double width, double height, int totalCards) {
    final baseSpacing = width < 400
        ? 8
        : width < 600
            ? 10
            : 14;
    int bestCols = 2;
    int bestRows = (totalCards / bestCols).ceil();
    double bestCardSize = 0;

    for (int cols = 2; cols <= totalCards; cols++) {
      final rows = (totalCards / cols).ceil();
      final totalHSpacing = (cols - 1) * baseSpacing;
      final totalVSpacing = (rows - 1) * baseSpacing;
      final availableWidth = width - totalHSpacing - 16;
      final availableHeight = height - totalVSpacing - 16;
      if (availableWidth <= 0 || availableHeight <= 0) continue;
      final size = (availableWidth / cols).clamp(40.0, availableHeight / rows);
      if (cols * rows >= totalCards && size > bestCardSize) {
        bestCardSize = size;
        bestCols = cols;
        bestRows = rows;
      }
    }

    final cardSize = bestCardSize.clamp(50.0, 160.0);
    final usedHeight = bestRows * cardSize + (bestRows - 1) * baseSpacing;
    final topPadding = ((height - usedHeight) / 2).clamp(0.0, double.infinity);

    return GridLayoutHelper(
      cols: bestCols,
      spacing: baseSpacing.toDouble(),
      cardSize: cardSize,
      topPadding: topPadding,
    );
  }
}
