import '../model/math_activity_type.dart';

class MathActivityRegistry {
  static const List<MathActivityDefinition> definitions =
      <MathActivityDefinition>[
    MathActivityDefinition(
      type: MathActivityType.countingSelectAnswer,
      group: MathActivityGroup.numberAndCounting,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.compareMoreLessEqual,
      group: MathActivityGroup.numberAndCounting,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.fillMissingNumberInSequence,
      group: MathActivityGroup.numberAndCounting,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.sortNumbersAscDesc,
      group: MathActivityGroup.numberAndCounting,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.addSubtractRange,
      group: MathActivityGroup.simpleOperations,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.pictureWordProblem,
      group: MathActivityGroup.simpleOperations,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.fillMathOperator,
      group: MathActivityGroup.simpleOperations,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.identifyShapes,
      group: MathActivityGroup.geometryAndSpace,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.compareSizeHeightLength,
      group: MathActivityGroup.geometryAndSpace,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.identifyPosition,
      group: MathActivityGroup.geometryAndSpace,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.oddOneOut,
      group: MathActivityGroup.classificationAndLogic,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.completePattern,
      group: MathActivityGroup.classificationAndLogic,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.matchingPairs,
      group: MathActivityGroup.classificationAndLogic,
      isImplemented: true,
    ),
    MathActivityDefinition(
      type: MathActivityType.findSameDifferent,
      group: MathActivityGroup.classificationAndLogic,
      isImplemented: true,
    ),
  ];

  static List<MathActivityDefinition> byGroup(MathActivityGroup group) {
    return definitions
        .where((MathActivityDefinition item) => item.group == group)
        .toList();
  }
}
