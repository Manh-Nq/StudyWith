import 'dart:math';

import 'package:flutter/material.dart';

import '../model/math_compare_question.dart';
import '../service/math_compare_generator.dart';
import '../../../shared/data/repository/math_entity_repository.dart';
import '../../../shared/model/math_entity_type.dart';

enum MathCompareSessionMode { practice, exam }

class MathCompareViewModel extends ChangeNotifier {
  MathCompareViewModel({
    MathEntityRepository? repository,
    MathCompareGenerator? generator,
  })  : _repository = repository ?? MathEntityRepository(),
        _generator = generator ?? MathCompareGenerator();
  final MathEntityRepository _repository;
  final MathCompareGenerator _generator;
  MathCompareSessionMode _sessionMode = MathCompareSessionMode.practice;
  int _examDurationMinutes = 15;
  int _secondsPerQuestion = 90;
  bool _loading = false;
  String _errorMessage = '';
  MathCompareQuestion? _question;
  int _score = 0;
  int _total = 0;
  int _traceQuestionOrdinal = 0;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  MathCompareQuestion? get question => _question;
  int get score => _score;
  int get total => _total;
  bool get isExamMode => _sessionMode == MathCompareSessionMode.exam;
  bool get showScore => isExamMode;
  int get examDurationMinutes => _examDurationMinutes;
  int get secondsPerQuestion => _secondsPerQuestion;
  int get traceQuestionOrdinal => _traceQuestionOrdinal;
  int get expectedExamQuestionCount {
    final int safeSeconds = max(10, _secondsPerQuestion);
    return max(1, (_examDurationMinutes * 60) ~/ safeSeconds);
  }

  void setSessionMode(MathCompareSessionMode mode) {
    _sessionMode = mode;
    _score = 0;
    _total = 0;
    _traceQuestionOrdinal = 0;
    notifyListeners();
  }

  void configureExam({
    required int durationMinutes,
    required int secondsPerQuestion,
  }) {
    _examDurationMinutes = max(1, durationMinutes);
    _secondsPerQuestion = max(10, secondsPerQuestion);
    setSessionMode(MathCompareSessionMode.exam);
  }

  Future<void> initialize() async {
    _loading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _repository.ensureSeedData();
      await nextQuestion();
    } catch (e) {
      _question = null;
      _errorMessage = 'Khong the tai du lieu Toan tu duy: $e';
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> nextQuestion() async {
    final List<MathEntityType> activeEntities = await _repository.getActive();
    if (activeEntities.isEmpty) {
      _question = null;
      _errorMessage =
          'Chua co vat dang bat. Hay them hoac bat vat o man quan ly.';
      notifyListeners();
      return;
    }
    _question = _generator.generate(activeEntities);
    _traceQuestionOrdinal++;
    _errorMessage = '';
    notifyListeners();
  }

  bool submitAnswer(MathCompareRelation selected) {
    final MathCompareQuestion? q = _question;
    if (q == null) {
      return false;
    }
    final bool correct = selected == q.correctRelation;
    if (isExamMode) {
      _total += 1;
      if (correct) {
        _score += 1;
      }
      notifyListeners();
    }
    return correct;
  }
}
