import '../../../shared/model/math_entity_type.dart';

class MathCountingQuestion {
  const MathCountingQuestion({
    required this.entityType,
    required this.correctAnswer,
    required this.wrongAnswer,
    required this.options,
  });
  final MathEntityType entityType;
  final int correctAnswer;
  final int wrongAnswer;
  final List<int> options;
}
