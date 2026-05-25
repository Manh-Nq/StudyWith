enum MathSortDirection { ascending, descending }

class MathSortQuestion {
  const MathSortQuestion({
    required this.unsorted,
    required this.direction,
    required this.correctAnswerText,
    required this.options,
  });
  final List<int> unsorted;
  final MathSortDirection direction;
  final String correctAnswerText;
  final List<String> options;
}
