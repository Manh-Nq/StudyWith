import 'dart:math';

import '../model/math_sort_question.dart';

class MathSortGenerator {
  MathSortGenerator({Random? random}) : _random = random ?? Random();
  final Random _random;

  MathSortQuestion generate() {
    final Set<int> raw = <int>{};
    while (raw.length < 4) {
      raw.add(1 + _random.nextInt(20));
    }
    final List<int> unsorted = raw.toList()..shuffle(_random);
    final MathSortDirection direction = _random.nextBool()
        ? MathSortDirection.ascending
        : MathSortDirection.descending;
    final List<int> ascending = List<int>.from(unsorted)..sort();
    // Never use setAll(0, sorted.reversed): reversed reads from sorted while
    // setAll mutates it in place and corrupts values (e.g. duplicated digits).
    final List<int> correctOrder = direction == MathSortDirection.descending
        ? ascending.reversed.toList()
        : List<int>.from(ascending);
    final String correct = _toAnswer(correctOrder);
    final List<String> options =
        _buildOptions(unsorted, correctOrder, correct);
    options.shuffle(_random);
    return MathSortQuestion(
      unsorted: unsorted,
      direction: direction,
      correctAnswerText: correct,
      options: options,
    );
  }

  List<String> _buildOptions(
    List<int> unsorted,
    List<int> correctOrder,
    String correct,
  ) {
    final Set<String> set = <String>{correct};
    set.add(_toAnswer(List<int>.from(unsorted)));
    final List<int> swapped = List<int>.from(correctOrder);
    if (swapped.length >= 2) {
      final int tmp = swapped[0];
      swapped[0] = swapped[1];
      swapped[1] = tmp;
      set.add(_toAnswer(swapped));
    }
    int tries = 0;
    while (set.length < 3 && tries < 60) {
      tries++;
      final List<int> randomOrder = List<int>.from(correctOrder)
        ..shuffle(_random);
      set.add(_toAnswer(randomOrder));
    }
    if (set.length < 3) {
      set.add(_toAnswer(correctOrder.reversed.toList()));
    }
    return set.toList();
  }

  String _toAnswer(List<int> values) {
    return values.join(', ');
  }
}
