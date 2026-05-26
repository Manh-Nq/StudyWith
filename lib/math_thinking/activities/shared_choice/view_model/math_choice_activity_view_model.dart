import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../model/math_choice_question.dart';

typedef MathChoiceGenerator = FutureOr<MathChoiceQuestion> Function();

enum MathChoiceSessionMode { practice, exam }

class MathChoiceActivityViewModel extends ChangeNotifier {
  MathChoiceActivityViewModel({required MathChoiceGenerator generator})
      : _generator = generator;
  final MathChoiceGenerator _generator;
  MathChoiceSessionMode _sessionMode = MathChoiceSessionMode.practice;
  int _examDurationMinutes = 15;
  int _secondsPerQuestion = 90;
  bool _loading = false;
  String _errorMessage = '';
  MathChoiceQuestion? _question;
  int _score = 0;
  int _total = 0;
  int _traceQuestionOrdinal = 0;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  MathChoiceQuestion? get question => _question;
  int get score => _score;
  int get total => _total;
  bool get isExamMode => _sessionMode == MathChoiceSessionMode.exam;
  bool get showScore => isExamMode;
  int get examDurationMinutes => _examDurationMinutes;
  int get secondsPerQuestion => _secondsPerQuestion;
  int get traceQuestionOrdinal => _traceQuestionOrdinal;
  int get expectedExamQuestionCount {
    final int safeSeconds = max(10, _secondsPerQuestion);
    return max(1, (_examDurationMinutes * 60) ~/ safeSeconds);
  }

  void setSessionMode(MathChoiceSessionMode mode) {
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
    setSessionMode(MathChoiceSessionMode.exam);
  }

  Future<void> initialize() async {
    _loading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await nextQuestion();
    } catch (e) {
      _question = null;
      final String message = e is StateError ? e.message : '$e';
      _errorMessage = message.isNotEmpty
          ? message
          : 'Không thể tạo câu hỏi.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> nextQuestion() async {
    _question = await _generator();
    _traceQuestionOrdinal++;
    _errorMessage = '';
    notifyListeners();
  }

  bool submitAnswer(int selectedIndex) {
    final MathChoiceQuestion? q = _question;
    if (q == null) {
      return false;
    }
    final bool correct = selectedIndex == q.correctIndex;
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
