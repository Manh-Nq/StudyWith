import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Kích thước UI bài toán có tranh (Material 3 spacing: 8 / 16 / 24).
class MathPictureAddLayoutMetrics {
  static const double materialSpaceSmall = 8;
  static const double materialSpaceMedium = 16;
  static const double materialSpaceLarge = 24;

  final double cardPadding;
  final double cardRadius;
  final double groupGap;
  final double sectionGap;
  final double operatorGlyphSize;
  final double equationBarHeight;
  final double equationChipMinWidth;
  final double equationChipGap;
  final double frameInset;
  final double numberFontSize;
  final double questionFontSize;
  final double minFrameHeightFraction;

  final double _shortestSide;

  factory MathPictureAddLayoutMetrics.fromConstraints({
    required BoxConstraints bodyConstraints,
    required Size screenSize,
  }) {
    final double width = bodyConstraints.maxWidth.isFinite
        ? bodyConstraints.maxWidth
        : screenSize.width;
    final double height = bodyConstraints.maxHeight.isFinite
        ? bodyConstraints.maxHeight
        : screenSize.height;
    final double shortest = math.min(width, height);
    final bool phone = shortest < 720;
    final double scale = (shortest / 390).clamp(0.88, 1.28);
    return MathPictureAddLayoutMetrics._(
      shortestSide: shortest,
      cardPadding: materialSpaceMedium * scale,
      cardRadius: 20 * scale,
      groupGap: materialSpaceMedium * scale,
      sectionGap: materialSpaceLarge * scale,
      operatorGlyphSize: phone ? 32 * scale : 38,
      equationBarHeight: (52 * scale).clamp(48, 64),
      equationChipMinWidth: (52 * scale).clamp(48, 60),
      equationChipGap: materialSpaceSmall * scale,
      frameInset: phone ? 8 : 12,
      numberFontSize: phone ? 26 * scale : 32,
      questionFontSize: phone ? 28 * scale : 34,
      minFrameHeightFraction: phone ? 0.34 : 0.28,
    );
  }

  const MathPictureAddLayoutMetrics._({
    required double shortestSide,
    required this.cardPadding,
    required this.cardRadius,
    required this.groupGap,
    required this.sectionGap,
    required this.operatorGlyphSize,
    required this.equationBarHeight,
    required this.equationChipMinWidth,
    required this.equationChipGap,
    required this.frameInset,
    required this.numberFontSize,
    required this.questionFontSize,
    required this.minFrameHeightFraction,
  }) : _shortestSide = shortestSide;

  double contentWidth(double totalWidth) {
    return math.max(1, totalWidth - cardPadding * 2);
  }

  double pictureGroupWidth(double totalWidth) {
    final double inner = contentWidth(totalWidth);
    final double plusColumn = operatorGlyphSize + groupGap;
    return math.max(1, (inner - plusColumn - groupGap) / 2);
  }

  double equationBarOuterHeight() {
    return equationBarHeight;
  }

  double equationSectionHeight() {
    return sectionGap + equationBarOuterHeight();
  }

  /// Chia chiều cao trong thẻ để Column không bao giờ tràn (kể cả viewport ~64px).
  MathPictureCardLayoutBudget layoutBudget(double bodyMaxHeight) {
    final double cardInnerH = math.max(
      0,
      bodyMaxHeight - cardPadding * 2,
    );
    final double eqPreferred = equationBarOuterHeight();
    const double minPictureH = 16;
    if (cardInnerH <= eqPreferred + minPictureH) {
      final double eqH = (cardInnerH * 0.48).clamp(28, eqPreferred);
      final double picH = math.max(0, cardInnerH - eqH);
      return MathPictureCardLayoutBudget(
        pictureHeight: picH,
        sectionGap: 0,
        equationHeight: eqH,
      );
    }
    double gap = sectionGap;
    if (cardInnerH < eqPreferred + sectionGap + 48) {
      gap = math.max(4, cardInnerH - eqPreferred - 48);
    }
    final double picH = math.max(minPictureH, cardInnerH - eqPreferred - gap);
    return MathPictureCardLayoutBudget(
      pictureHeight: picH,
      sectionGap: gap,
      equationHeight: eqPreferred,
    );
  }

  double estimatePictureAreaHeight(double bodyMaxHeight) {
    return layoutBudget(bodyMaxHeight).pictureHeight;
  }

  double innerWidth(double groupWidth) {
    return math.max(1, groupWidth - frameInset);
  }

  double innerHeight(double maxFrameHeight, double paddingValue) {
    return math.max(1, maxFrameHeight - paddingValue * 2);
  }

  double minFrameHeight(int maxCount, double maxFrameHeight) {
    if (maxCount > 10) {
      return 0;
    }
    if (maxCount <= 2) {
      return maxFrameHeight * (minFrameHeightFraction * 0.75);
    }
    return maxFrameHeight * minFrameHeightFraction;
  }

  double targetInnerHeight({
    required int maxCount,
    required double maxFrameHeight,
    required double paddingValue,
  }) {
    final double natural = innerHeight(maxFrameHeight, paddingValue);
    final double minFrame = minFrameHeight(maxCount, maxFrameHeight);
    if (minFrame <= 0) {
      return natural;
    }
    return math.max(natural, minFrame - paddingValue * 2);
  }

  double maxCellSize(int count) {
    final double fromScreen = _shortestSide * 0.17;
    if (count <= 6) {
      return fromScreen.clamp(56, 88);
    }
    if (count <= 20) {
      return fromScreen.clamp(48, 72);
    }
    if (count <= 100) {
      return fromScreen.clamp(28, 40);
    }
    return 24;
  }

  double minCellSize(int count) {
    if (count <= 6) {
      return 28;
    }
    if (count <= 20) {
      return 22;
    }
    if (count <= 100) {
      return 10;
    }
    return 4;
  }
}

/// Chiều cao từng vùng trong thẻ bài toán (tổng ≤ chiều cao khả dụng).
class MathPictureCardLayoutBudget {
  const MathPictureCardLayoutBudget({
    required this.pictureHeight,
    required this.sectionGap,
    required this.equationHeight,
  });

  final double pictureHeight;
  final double sectionGap;
  final double equationHeight;

  double get totalHeight => pictureHeight + sectionGap + equationHeight;
}
