import 'package:location_app/l10n/app_localizations.dart';

import 'package:location_app/math_thinking/model/math_activity_type.dart';

class MathActivityL10n {
  const MathActivityL10n._();

  static String title(AppLocalizations l, MathActivityType type) {
    switch (type) {
      case MathActivityType.countingSelectAnswer:
        return l.mathActCountingTitle;
      case MathActivityType.compareMoreLessEqual:
        return l.mathActCompareTitle;
      case MathActivityType.fillMissingNumberInSequence:
        return l.mathActSequenceTitle;
      case MathActivityType.sortNumbersAscDesc:
        return l.mathActSortTitle;
      case MathActivityType.addSubtractRange:
        return l.mathActAddSubTitle;
      case MathActivityType.pictureWordProblem:
        return l.mathActPictureTitle;
      case MathActivityType.fillMathOperator:
        return l.mathActFillOpTitle;
      case MathActivityType.identifyShapes:
        return l.mathActShapesTitle;
      case MathActivityType.compareSizeHeightLength:
        return l.mathActSizeCompareTitle;
      case MathActivityType.identifyPosition:
        return l.mathActPositionTitle;
      case MathActivityType.oddOneOut:
        return l.mathActOddOneTitle;
      case MathActivityType.completePattern:
        return l.mathActPatternTitle;
      case MathActivityType.matchingPairs:
        return l.mathActMatchingTitle;
      case MathActivityType.findSameDifferent:
        return l.mathActSameDiffTitle;
    }
  }

  static String description(AppLocalizations l, MathActivityType type) {
    switch (type) {
      case MathActivityType.countingSelectAnswer:
        return l.mathActCountingDesc;
      case MathActivityType.compareMoreLessEqual:
        return l.mathActCompareDesc;
      case MathActivityType.fillMissingNumberInSequence:
        return l.mathActSequenceDesc;
      case MathActivityType.sortNumbersAscDesc:
        return l.mathActSortDesc;
      case MathActivityType.addSubtractRange:
        return l.mathActAddSubDesc;
      case MathActivityType.pictureWordProblem:
        return l.mathActPictureDesc;
      case MathActivityType.fillMathOperator:
        return l.mathActFillOpDesc;
      case MathActivityType.identifyShapes:
        return l.mathActShapesDesc;
      case MathActivityType.compareSizeHeightLength:
        return l.mathActSizeCompareDesc;
      case MathActivityType.identifyPosition:
        return l.mathActPositionDesc;
      case MathActivityType.oddOneOut:
        return l.mathActOddOneDesc;
      case MathActivityType.completePattern:
        return l.mathActPatternDesc;
      case MathActivityType.matchingPairs:
        return l.mathActMatchingDesc;
      case MathActivityType.findSameDifferent:
        return l.mathActSameDiffDesc;
    }
  }

  static String groupTitle(AppLocalizations l, MathActivityGroup group) {
    switch (group) {
      case MathActivityGroup.numberAndCounting:
        return l.mathGroupNumberCounting;
      case MathActivityGroup.simpleOperations:
        return l.mathGroupSimpleOperations;
      case MathActivityGroup.geometryAndSpace:
        return l.mathGroupGeometrySpace;
      case MathActivityGroup.classificationAndLogic:
        return l.mathGroupClassificationLogic;
    }
  }
}
