import 'dart:math';

import 'package:location_app/language_study/data/dictionary_models.dart';
import 'package:location_app/language_study/model/language_study_quiz_question.dart';

/// Sinh câu trắc nghiệm nghĩa từ danh sách từ đã có nghĩa xem trước.
abstract final class LanguageStudyQuizGenerator {
  static const int choiceCount = 4;

  static List<LanguageStudyQuizQuestion> fromListItems(
    List<DictionaryListItem> items,
  ) {
    final List<DictionaryListItem> withMeaning = items
        .where(
          (DictionaryListItem e) =>
              e.meaningPreview != null && e.meaningPreview!.trim().isNotEmpty,
        )
        .toList();
    if (withMeaning.isEmpty) {
      return <LanguageStudyQuizQuestion>[];
    }
    final List<String> meaningPool = withMeaning
        .map((DictionaryListItem e) => e.meaningPreview!.trim())
        .toSet()
        .toList();
    final Random rng = Random();
    final List<LanguageStudyQuizQuestion> out = <LanguageStudyQuizQuestion>[];
    for (final DictionaryListItem item in withMeaning) {
      final String correct = item.meaningPreview!.trim();
      final List<String> distractors = meaningPool
          .where((String m) => m != correct)
          .toList()
        ..shuffle(rng);
      final List<String> wrong = distractors.take(choiceCount - 1).toList();
      while (wrong.length < choiceCount - 1) {
        wrong.add('—');
      }
      final List<String> choices = <String>[correct, ...wrong]..shuffle(rng);
      out.add(
        LanguageStudyQuizQuestion(
          wordId: item.wordId,
          headword: item.headword,
          ipaPreview: item.ipaPreview,
          correctMeaning: correct,
          choices: choices,
          correctChoiceIndex: choices.indexOf(correct),
        ),
      );
    }
    out.shuffle(rng);
    return out;
  }
}
