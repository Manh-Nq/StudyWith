import 'dart:math' as math;

/// Bố cục lưới trong khung tranh: ưu tiên ô to, thu nhỏ / thêm cột để không tràn khung.
class MathPictureAddGridLayout {
  const MathPictureAddGridLayout({
    required this.columns,
    required this.rows,
    required this.cellSize,
    required this.gap,
    required this.padding,
  });

  final int columns;
  final int rows;
  final double cellSize;
  final double gap;
  final double padding;

  static const double paddingValue = 10;
  static const double gapValue = 8;
  static const double minReadableCell = 6;
  static const double _maxCellChild = 56;
  static const double _maxCellDense = 40;

  double emojiFontSizeFor(double maxEmoji) =>
      (cellSize * 0.82).clamp(8, maxEmoji);

  double get contentWidth =>
      columns * cellSize + math.max(0, columns - 1) * gap;

  double get contentHeight =>
      rows * cellSize + math.max(0, rows - 1) * gap;

  /// Chiều cao khung tranh (không gồm số bên dưới).
  double get frameHeight => padding * 2 + contentHeight;

  static int _preferredMaxColumns(int count) {
    if (count <= 1) {
      return 1;
    }
    if (count <= 3) {
      return count;
    }
    if (count <= 6) {
      return 3;
    }
    if (count <= 12) {
      return 4;
    }
    if (count <= 30) {
      return 5;
    }
    if (count <= 100) {
      return 8;
    }
    if (count <= 500) {
      return 12;
    }
    if (count <= 2000) {
      final int fromSqrt = (math.sqrt(count) * 2.2).ceil();
      return math.min(count, math.max(20, fromSqrt));
    }
    return math.min(count, 40);
  }

  static double _maxCellForCount(int count) {
    if (count <= 20) {
      return _maxCellChild;
    }
    return _maxCellDense;
  }

  static int _columnSearchUpper(
    int count,
    double innerWidth,
    double minCell,
  ) {
    final int widthCap = math.max(
      1,
      ((innerWidth + gapValue) / (minCell + gapValue)).floor(),
    );
    return math.min(count, math.max(_preferredMaxColumns(count), widthCap));
  }

  static bool _fits({
    required int columns,
    required int rows,
    required double cell,
    required double innerWidth,
    required double innerHeight,
  }) {
    final double w = columns * cell + math.max(0, columns - 1) * gapValue;
    final double h = rows * cell + math.max(0, rows - 1) * gapValue;
    return w <= innerWidth - 1 && h <= innerHeight - 1;
  }

  static double _clampCellToFit({
    required int columns,
    required int rows,
    required double cell,
    required double innerWidth,
    required double innerHeight,
  }) {
    double fitted = cell;
    while (fitted > 1 &&
        !_fits(
          columns: columns,
          rows: rows,
          cell: fitted,
          innerWidth: innerWidth,
          innerHeight: innerHeight,
        )) {
      fitted -= 0.25;
    }
    return math.max(1, fitted);
  }

  /// Chọn lưới sao cho nội dung nằm trọn trong [innerWidth] × [innerHeight].
  static MathPictureAddGridLayout compute({
    required int count,
    required double innerWidth,
    required double innerHeight,
    double? maxCellOverride,
    double? minCellOverride,
  }) {
    final double maxCellLimit = maxCellOverride ?? _maxCellForCount(count);
    final double minCell = minCellOverride ?? minReadableCell;
    final double safeW = math.max(1, innerWidth);
    final double safeH = math.max(1, innerHeight);
    if (count <= 0) {
      return const MathPictureAddGridLayout(
        columns: 1,
        rows: 1,
        cellSize: minReadableCell,
        gap: gapValue,
        padding: paddingValue,
      );
    }
    final int colLimit = _columnSearchUpper(count, safeW, minCell);
    int bestCols = 1;
    double bestCell = 0;
    for (int cols = 1; cols <= colLimit; cols++) {
      final int rows = (count + cols - 1) ~/ cols;
      final double cellByW = (safeW - (cols - 1) * gapValue) / cols;
      final double cellByH = (safeH - (rows - 1) * gapValue) / rows;
      final double raw = math.min(cellByW, cellByH);
      if (raw <= 0) {
        continue;
      }
      final double cell = math.min(raw, maxCellLimit);
      if (!_fits(
        columns: cols,
        rows: rows,
        cell: cell,
        innerWidth: safeW,
        innerHeight: safeH,
      )) {
        continue;
      }
      if (cell > bestCell) {
        bestCell = cell;
        bestCols = cols;
      }
    }
    if (bestCell > 0) {
      final int rows = (count + bestCols - 1) ~/ bestCols;
      final double cell = _clampCellToFit(
        columns: bestCols,
        rows: rows,
        cell: bestCell,
        innerWidth: safeW,
        innerHeight: safeH,
      );
      return MathPictureAddGridLayout(
        columns: bestCols,
        rows: rows,
        cellSize: cell,
        gap: gapValue,
        padding: paddingValue,
      );
    }
    final int cols = colLimit;
    final int rows = (count + cols - 1) ~/ cols;
    final double cellByW = (safeW - (cols - 1) * gapValue) / cols;
    final double cellByH = (safeH - (rows - 1) * gapValue) / rows;
    final double raw = math.min(math.min(cellByW, cellByH), maxCellLimit);
    final double cell = _clampCellToFit(
      columns: cols,
      rows: rows,
      cell: math.max(minCell, raw),
      innerWidth: safeW,
      innerHeight: safeH,
    );
    return MathPictureAddGridLayout(
      columns: cols,
      rows: rows,
      cellSize: cell,
      gap: gapValue,
      padding: paddingValue,
    );
  }
}
