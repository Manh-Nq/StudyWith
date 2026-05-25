import 'dart:math';

import 'package:flutter/material.dart';

import '../model/math_add_sub_question.dart';
import '../service/math_add_sub_generator.dart';

enum MathAddSubSessionMode { practice, exam }

class MathAddSubViewModel extends ChangeNotifier {
  MathAddSubViewModel({MathAddSubGenerator? generator})
      : _generator = generator ?? MathAddSubGenerator();
  final MathAddSubGenerator _generator;
  MathAddSubSessionMode _sessionMode = MathAddSubSessionMode.practice;
  int _examDurationMinutes = 15;
  int _secondsPerQuestion = 90;
  bool _loading = false;
  String _errorMessage = '';
  MathAddSubQuestion? _question;
  int _score = 0;
  int _total = 0;
  int _traceQuestionOrdinal = 0;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  MathAddSubQuestion? get question => _question;
  int get score => _score;
  int get total => _total;
  bool get isExamMode => _sessionMode == MathAddSubSessionMode.exam;
  bool get showScore => isExamMode;
  int get examDurationMinutes => _examDurationMinutes;
  int get secondsPerQuestion => _secondsPerQuestion;
  int get traceQuestionOrdinal => _traceQuestionOrdinal;
  int get expectedExamQuestionCount {
    final int safeSeconds = max(10, _secondsPerQuestion);
    return max(1, (_examDurationMinutes * 60) ~/ safeSeconds);
  }

  void setSessionMode(MathAddSubSessionMode mode) {
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
    setSessionMode(MathAddSubSessionMode.exam);
  }

  Future<void> initialize() async {
    _loading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await nextQuestion();
    } catch (e) {
      _question = null;
      _errorMessage = 'Không thể tạo câu hỏi cộng/trừ: $e';
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

  bool submitAnswer(int selected) {
    final MathAddSubQuestion? q = _question;
    if (q == null) {
      return false;
    }
    final bool correct = selected == q.correctAnswer;
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
