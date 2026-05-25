import 'dart:convert';

import 'package:location_app/math_thinking/activities/add_sub/model/math_add_sub_question.dart';
import 'package:location_app/math_thinking/activities/compare/model/math_compare_question.dart';
import 'package:location_app/math_thinking/activities/counting/model/math_counting_question.dart';
import 'package:location_app/math_thinking/activities/sequence/model/math_sequence_question.dart';
import 'package:location_app/math_thinking/activities/shared_choice/model/math_choice_question.dart';
import 'package:location_app/math_thinking/activities/sort/model/math_sort_question.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';
import 'package:location_app/math_thinking/shared/model/math_entity_type.dart';

/// JSON snapshot cho mục Theo dõi (toán): gói câu hỏi + đáp án người học.
abstract final class MathTraceSnapshot {
  static String wrap({
    required MathActivityType activityType,
    required bool isCorrect,
    required Map<String, Object?> payload,
    required int questionOrdinal,
  }) {
    return jsonEncode(<String, Object?>{
      'v': 1,
      'mathActivityType': activityType.name,
      'isCorrect': isCorrect,
      'questionOrdinal': questionOrdinal,
      'payload': payload,
    });
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

  static MathActivityType? parseActivityType(Map<String, Object?> root) {
    final Object? raw = root['mathActivityType'];
    if (raw is! String) {
      return null;
    }
    try {
      return MathActivityType.values.byName(raw);
    } on ArgumentError {
      return null;
    }
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

  static bool parseIsCorrect(Map<String, Object?> root) {
    final Object? v = root['isCorrect'];
    if (v is bool) {
      return v;
    }
    if (v is num) {
      return v != 0;
    }
    return false;
  }

  static Map<String, Object?> entityToJson(MathEntityType e) {
    return e.toMap();
  }

  static MathEntityType entityFromJson(Map<String, Object?> m) {
    return MathEntityType.fromMap(m);
  }

  static String counting({
    required MathActivityType activityType,
    required bool isCorrect,
    required int questionOrdinal,
    required MathCountingQuestion question,
    required int userAnswer,
  }) {
    return wrap(
      activityType: activityType,
      isCorrect: isCorrect,
      questionOrdinal: questionOrdinal,
      payload: <String, Object?>{
        'kind': 'counting',
        'entity': entityToJson(question.entityType),
        'options': question.options,
        'userAnswer': userAnswer,
        'correctAnswer': question.correctAnswer,
      },
    );
  }

  static String compare({
    required MathActivityType activityType,
    required bool isCorrect,
    required int questionOrdinal,
    required MathCompareQuestion question,
    required MathCompareRelation userRelation,
  }) {
    return wrap(
      activityType: activityType,
      isCorrect: isCorrect,
      questionOrdinal: questionOrdinal,
      payload: <String, Object?>{
        'kind': 'compare',
        'leftEntity': entityToJson(question.leftEntity),
        'rightEntity': entityToJson(question.rightEntity),
        'leftCount': question.leftCount,
        'rightCount': question.rightCount,
        'options':
            question.options.map((MathCompareRelation r) => r.name).toList(),
        'correctRelation': question.correctRelation.name,
        'userRelation': userRelation.name,
      },
    );
  }

  static String sequence({
    required MathActivityType activityType,
    required bool isCorrect,
    required int questionOrdinal,
    required MathSequenceQuestion question,
    required int userAnswer,
  }) {
    return wrap(
      activityType: activityType,
      isCorrect: isCorrect,
      questionOrdinal: questionOrdinal,
      payload: <String, Object?>{
        'kind': 'sequence',
        'sequence': question.sequence.map((int? n) => n).toList(),
        'options': question.options,
        'userAnswer': userAnswer,
        'correctAnswer': question.correctAnswer,
      },
    );
  }

  static String sort({
    required MathActivityType activityType,
    required bool isCorrect,
    required int questionOrdinal,
    required MathSortQuestion question,
    required String userOption,
  }) {
    return wrap(
      activityType: activityType,
      isCorrect: isCorrect,
      questionOrdinal: questionOrdinal,
      payload: <String, Object?>{
        'kind': 'sort',
        'unsorted': question.unsorted,
        'direction': question.direction.name,
        'options': question.options,
        'correctAnswerText': question.correctAnswerText,
        'userOption': userOption,
      },
    );
  }

  static String addSub({
    required MathActivityType activityType,
    required bool isCorrect,
    required int questionOrdinal,
    required MathAddSubQuestion question,
    required int userAnswer,
  }) {
    return wrap(
      activityType: activityType,
      isCorrect: isCorrect,
      questionOrdinal: questionOrdinal,
      payload: <String, Object?>{
        'kind': 'addSub',
        'left': question.left,
        'right': question.right,
        'operator': question.operatorType.name,
        'options': question.options,
        'userAnswer': userAnswer,
        'correctAnswer': question.correctAnswer,
      },
    );
  }

  static String choice({
    required MathActivityType activityType,
    required bool isCorrect,
    required int questionOrdinal,
    required MathChoiceQuestion question,
    required int userIndex,
    required String screenTitle,
  }) {
    return wrap(
      activityType: activityType,
      isCorrect: isCorrect,
      questionOrdinal: questionOrdinal,
      payload: <String, Object?>{
        'kind': 'choice',
        'screenTitle': screenTitle,
        'questionText': question.questionText,
        'hintText': question.hintText,
        'options': question.options,
        'userIndex': userIndex,
        'correctIndex': question.correctIndex,
        'meta': question.meta,
      },
    );
  }
}
