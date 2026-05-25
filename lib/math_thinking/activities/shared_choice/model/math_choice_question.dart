class MathChoiceQuestion {
  const MathChoiceQuestion({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.hintText = '',
    this.meta = const <String, String>{},
  });
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String hintText;
  final Map<String, String> meta;
}
