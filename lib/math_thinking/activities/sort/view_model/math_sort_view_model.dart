import 'dart:math';

import 'package:flutter/material.dart';

import '../model/math_sort_question.dart';
import '../service/math_sort_generator.dart';

enum MathSortSessionMode { practice, exam }

class MathSortViewModel extends ChangeNotifier {
  MathSortViewModel({MathSortGenerator? generator})
      : _generator = generator ?? MathSortGenerator();
  final MathSortGenerator _generator;
  MathSortSessionMode _sessionMode = MathSortSessionMode.practice;
  int _examDurationMinutes = 15;
  int _secondsPerQuestion = 90;
  bool _loading = false;
  String _errorMessage = '';
  MathSortQuestion? _question;
  int _score = 0;
  int _total = 0;
  int _traceQuestionOrdinal = 0;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  MathSortQuestion? get question => _question;
  int get score => _score;
  int get total => _total;
  bool get isExamMode => _sessionMode == MathSortSessionMode.exam;
  bool get showScore => isExamMode;
  int get examDurationMinutes => _examDurationMinutes;
  int get secondsPerQuestion => _secondsPerQuestion;
  int get traceQuestionOrdinal => _traceQuestionOrdinal;
  int get expectedExamQuestionCount {
    final int safeSeconds = max(10, _secondsPerQuestion);
    return max(1, (_examDurationMinutes * 60) ~/ safeSeconds);
  }

  void setSessionMode(MathSortSessionMode mode) {
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
    setSessionMode(MathSortSessionMode.exam);
  }

  Future<void> initialize() async {
    _loading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await nextQuestion();
    } catch (e) {
      _question = null;
      _errorMessage = 'Khong the tao cau hoi sap xep so: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> nextQuestion() async {
    _question = _generator.generate();
    _traceQuestionOrdinal++;
    _errorMessage = '';
    notifyListeners();
  }

  bool submitAnswer(String selected) {
    final MathSortQuestion? q = _question;
    if (q == null) {
      return false;
    }
    final bool correct = selected == q.correctAnswerText;
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
