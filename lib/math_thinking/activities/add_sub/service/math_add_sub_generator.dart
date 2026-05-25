import 'dart:math';

import '../model/math_add_sub_question.dart';

class MathAddSubGenerator {
  MathAddSubGenerator({Random? random}) : _random = random ?? Random();
  final Random _random;

  MathAddSubQuestion generate() {
    final bool easyRange = _random.nextBool();
    final int maxValue = easyRange ? 10 : 20;
    final MathAddSubOperator op = _random.nextBool()
        ? MathAddSubOperator.add
        : MathAddSubOperator.subtract;
    int left = 1 + _random.nextInt(maxValue);
    int right = 1 + _random.nextInt(maxValue);
    if (op == MathAddSubOperator.add) {
      while (left + right > maxValue) {
        left = 1 + _random.nextInt(maxValue);
        right = 1 + _random.nextInt(maxValue);
      }
    } else {
      if (right > left) {
        final int tmp = left;
        left = right;
        right = tmp;
      }
    }
    final int answer =
        op == MathAddSubOperator.add ? left + right : left - right;
    final List<int> options = _buildOptions(answer, maxValue);
    options.shuffle(_random);
    return MathAddSubQuestion(
      left: left,
      right: right,
      operatorType: op,
      correctAnswer: answer,
      options: options,
    );
  }

  List<int> _buildOptions(int answer, int maxValue) {
    final Set<int> set = <int>{answer};
    while (set.length < 3) {
      final int delta = 1 + _random.nextInt(4);
      final int candidate =
          _random.nextBool() ? answer + delta : answer - delta;
      if (candidate >= 0 && candidate <= maxValue) {
        set.add(candidate);
      }
    }
    return set.toList();
  }
}
