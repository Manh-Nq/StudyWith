import 'dart:math';

import 'package:flutter/material.dart';

import '../model/math_sequence_pattern_mode.dart';
import '../model/math_sequence_question.dart';
import '../service/math_sequence_generator.dart';

enum MathSequenceSessionMode { practice, exam }

class MathSequenceViewModel extends ChangeNotifier {
  MathSequenceViewModel({
    required this.patternMode,
    MathSequenceGenerator? generator,
  }) : _generator = generator ?? MathSequenceGenerator();

  final MathSequencePatternMode patternMode;
  final MathSequenceGenerator _generator;
  MathSequenceSessionMode _sessionMode = MathSequenceSessionMode.practice;
  int _examDurationMinutes = 15;
  int _secondsPerQuestion = 90;
  bool _loading = false;
  String _errorMessage = '';
  MathSequenceQuestion? _question;
  int _score = 0;
  int _total = 0;
  int _traceQuestionOrdinal = 0;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  MathSequenceQuestion? get question => _question;
  int get score => _score;
  int get total => _total;
  bool get isExamMode => _sessionMode == MathSequenceSessionMode.exam;
  bool get showScore => isExamMode;
  int get examDurationMinutes => _examDurationMinutes;
  int get secondsPerQuestion => _secondsPerQuestion;
  int get traceQuestionOrdinal => _traceQuestionOrdinal;
  MathSequencePatternMode get sequencePatternMode => patternMode;
  int get expectedExamQuestionCount {
    final int safeSeconds = max(10, _secondsPerQuestion);
    return max(1, (_examDurationMinutes * 60) ~/ safeSeconds);
  }

  void setSessionMode(MathSequenceSessionMode mode) {
    _sessionMode = mode;
    _score = 0;
    _total = 0;
    _traceQuestionOrdinal = 0;
    if (patternMode == MathSequencePatternMode.consecutive) {
      _generator.resetConsecutiveProgress();
    }
    notifyListeners();
  }

  void configureExam({
    required int durationMinutes,
    required int secondsPerQuestion,
  }) {
    _examDurationMinutes = max(1, durationMinutes);
    _secondsPerQuestion = max(10, secondsPerQuestion);
    setSessionMode(MathSequenceSessionMode.exam);
  }

  Future<void> initialize() async {
    _loading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await nextQuestion();
    } catch (e) {
      _question = null;
      _errorMessage = 'Không thể tạo câu hỏi dãy số: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> nextQuestion() async {
    _question = _generator.generate(patternMode);
    _traceQuestionOrdinal++;
    _errorMessage = '';
    notifyListeners();
  }

  bool submitAnswer(int selected) {
    final MathSequenceQuestion? q = _question;
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
