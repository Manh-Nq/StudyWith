/// Một câu kiểm tra: từ tiếng Anh + chọn nghĩa tiếng Việt.
class LanguageStudyQuizQuestion {
  const LanguageStudyQuizQuestion({
    required this.wordId,
    required this.headword,
    required this.correctMeaning,
    required this.choices,
    required this.correctChoiceIndex,
    this.ipaPreview,
  });

  final int wordId;
  final String headword;
  final String? ipaPreview;
  final String correctMeaning;
  final List<String> choices;
  final int correctChoiceIndex;
}
