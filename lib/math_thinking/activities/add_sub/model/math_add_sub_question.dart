enum MathAddSubOperator { add, subtract }

class MathAddSubQuestion {
  const MathAddSubQuestion({
    required this.left,
    required this.right,
    required this.operatorType,
    required this.correctAnswer,
    required this.options,
  });
  final int left;
  final int right;
  final MathAddSubOperator operatorType;
  final int correctAnswer;
  final List<int> options;
}
