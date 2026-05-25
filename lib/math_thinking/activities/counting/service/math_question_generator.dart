import 'dart:math';

import '../model/math_counting_question.dart';
import '../../../shared/model/math_entity_type.dart';

class MathQuestionGenerator {
  MathQuestionGenerator({Random? random}) : _random = random ?? Random();
  final Random _random;

  MathCountingQuestion generateCountingQuestion(List<MathEntityType> entities) {
    if (entities.isEmpty) {
      throw StateError('No active entities found');
    }
    final MathEntityType selected = entities[_random.nextInt(entities.length)];
    final int correct = 1 + _random.nextInt(9);
    final int wrong = _generateNearbyWrong(correct);
    final bool correctFirst = _random.nextBool();
    final List<int> options =
        correctFirst ? <int>[correct, wrong] : <int>[wrong, correct];
    return MathCountingQuestion(
      entityType: selected,
      correctAnswer: correct,
      wrongAnswer: wrong,
      options: options,
    );
  }

  int _generateNearbyWrong(int correct) {
    final List<int> candidates = <int>[
      if (correct - 1 >= 1) correct - 1,
      if (correct + 1 <= 10) correct + 1,
      if (correct - 2 >= 1) correct - 2,
      if (correct + 2 <= 10) correct + 2,
    ];
    if (candidates.isEmpty) {
      return correct == 1 ? 2 : correct - 1;
    }
    return candidates[_random.nextInt(candidates.length)];
  }
}
