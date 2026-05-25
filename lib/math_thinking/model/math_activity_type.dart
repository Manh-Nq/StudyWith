enum MathActivityGroup {
  numberAndCounting,
  simpleOperations,
  geometryAndSpace,
  classificationAndLogic,
}

enum MathActivityType {
  countingSelectAnswer,
  compareMoreLessEqual,
  fillMissingNumberInSequence,
  sortNumbersAscDesc,
  addSubtractRange,
  pictureWordProblem,
  fillMathOperator,
  identifyShapes,
  compareSizeHeightLength,
  identifyPosition,
  oddOneOut,
  completePattern,
  matchingPairs,
  findSameDifferent,
}

class MathActivityDefinition {
  const MathActivityDefinition({
    required this.type,
    required this.group,
    required this.isImplemented,
  });
  final MathActivityType type;
  final MathActivityGroup group;
  final bool isImplemented;
}
