import 'package:flutter/material.dart';

import '../model/math_activity_type.dart';

/// Icon minh hoạ từng dạng bài trên menu danh sách.
IconData mathActivityMenuIcon(MathActivityType type) {
  switch (type) {
    case MathActivityType.countingSelectAnswer:
      return Icons.filter_1_rounded;
    case MathActivityType.compareMoreLessEqual:
      return Icons.compare_arrows_rounded;
    case MathActivityType.fillMissingNumberInSequence:
      return Icons.format_list_numbered_rounded;
    case MathActivityType.sortNumbersAscDesc:
      return Icons.sort_rounded;
    case MathActivityType.addSubtractRange:
      return Icons.add_circle_outline_rounded;
    case MathActivityType.pictureWordProblem:
      return Icons.image_rounded;
    case MathActivityType.fillMathOperator:
      return Icons.percent_rounded;
    case MathActivityType.identifyShapes:
      return Icons.category_rounded;
    case MathActivityType.compareSizeHeightLength:
      return Icons.straighten_rounded;
    case MathActivityType.identifyPosition:
      return Icons.place_rounded;
    case MathActivityType.oddOneOut:
      return Icons.looks_one_rounded;
    case MathActivityType.completePattern:
      return Icons.grid_on_rounded;
    case MathActivityType.matchingPairs:
      return Icons.link_rounded;
    case MathActivityType.findSameDifferent:
      return Icons.difference_rounded;
  }
}
