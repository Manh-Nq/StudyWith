class MathSequenceQuestion {
  const MathSequenceQuestion({
    required this.sequence,
    required this.correctAnswer,
    required this.options,
  });
  final List<int?> sequence;
  final int correctAnswer;
  final List<int> options;
}
