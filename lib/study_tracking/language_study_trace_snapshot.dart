import 'dart:convert';

import 'package:location_app/language_study/model/language_study_quiz_question.dart';

/// JSON snapshot cho Theo dõi — bài kiểm tra ngoại ngữ.
abstract final class LanguageStudyTraceSnapshot {
  static const String subjectKey = 'languageStudy';

  static String meaningChoice({
    required String pairId,
    required int questionOrdinal,
    required bool isCorrect,
    required LanguageStudyQuizQuestion question,
    required String userChoice,
    required int userChoiceIndex,
  }) {
    return jsonEncode(<String, Object?>{
      'v': 1,
      'subject': subjectKey,
      'pairId': pairId,
      'isCorrect': isCorrect,
      'questionOrdinal': questionOrdinal,
      'payload': <String, Object?>{
        'kind': 'meaningChoice',
        'headword': question.headword,
        'ipa': question.ipaPreview,
        'correctMeaning': question.correctMeaning,
        'userChoice': userChoice,
        'userChoiceIndex': userChoiceIndex,
        'correctChoiceIndex': question.correctChoiceIndex,
        'choices': question.choices,
      },
    });
  }

  static bool isLanguageStudy(Map<String, Object?> root) {
    return root['subject'] == subjectKey;
  }

  static Map<String, Object?> unwrap(String json) {
    final Object? decoded = jsonDecode(json);
    if (decoded is Map<String, Object?>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map(
        (Object? k, Object? v) => MapEntry(k!.toString(), v),
      );
    }
    return <String, Object?>{};
  }

  static int? parseQuestionOrdinal(Map<String, Object?> root) {
    final Object? v = root['questionOrdinal'];
    if (v is int) {
      return v;
    }
    if (v is num) {
      return v.toInt();
    }
    return null;
  }

  static bool parseIsCorrect(Map<String, Object?> root) {
    final Object? v = root['isCorrect'];
    return v == true;
  }

  static Map<String, Object?> payloadMap(Map<String, Object?> root) {
    final Object? p = root['payload'];
    if (p is Map<String, Object?>) {
      return p;
    }
    if (p is Map) {
      return p.map(
        (Object? k, Object? v) => MapEntry(k!.toString(), v),
      );
    }
    return <String, Object?>{};
  }
}
