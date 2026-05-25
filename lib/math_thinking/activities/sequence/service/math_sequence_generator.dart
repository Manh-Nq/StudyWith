import 'dart:math';

import '../model/math_sequence_pattern_mode.dart';
import '../model/math_sequence_question.dart';

class MathSequenceGenerator {
  MathSequenceGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// Vị trí bắt đầu dãy liên tục (1,2,3…) — tăng sau mỗi câu.
  int _consecutiveStart = 1;

  void resetConsecutiveProgress() {
    _consecutiveStart = 1;
  }

  MathSequenceQuestion generate(MathSequencePatternMode mode) {
    final int step;
    final int start;
    if (mode == MathSequencePatternMode.consecutive) {
      step = 1;
      start = _consecutiveStart;
      _consecutiveStart += 5;
      if (_consecutiveStart > 16) {
        _consecutiveStart = 1;
      }
    } else {
      step = 1 + _random.nextInt(3);
      start = 1 + _random.nextInt(8);
    }
    final List<int> full = List<int>.generate(5, (int i) => start + i * step);
    final int missingIndex = 1 + _random.nextInt(3);
    final int answer = full[missingIndex];
    final List<int?> sequence = List<int?>.from(full);
    sequence[missingIndex] = null;
    final List<int> options = _buildOptions(answer, step: step);
    options.shuffle(_random);
    return MathSequenceQuestion(
      sequence: sequence,
      correctAnswer: answer,
      options: options,
    );
  }

  List<int> _buildOptions(int answer, {required int step}) {
    final Set<int> set = <int>{answer};
    final int deltaBase = step == 1 ? 1 : step;
    while (set.length < 3) {
      final int delta = deltaBase + _random.nextInt(2);
      final bool plus = _random.nextBool();
      final int candidate = plus ? answer + delta : answer - delta;
      if (candidate > 0) {
        set.add(candidate);
      }
    }
    return set.toList();
  }
}
