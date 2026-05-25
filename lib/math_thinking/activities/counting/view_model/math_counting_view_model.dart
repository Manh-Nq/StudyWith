import 'dart:math';

import 'package:flutter/material.dart';

import '../model/math_counting_question.dart';
import '../service/math_question_generator.dart';
import '../../../shared/data/repository/math_entity_repository.dart';
import '../../../shared/model/math_entity_type.dart';

enum MathSessionMode { practice, exam }

class MathCountingViewModel extends ChangeNotifier {
  MathCountingViewModel({
    MathEntityRepository? repository,
    MathQuestionGenerator? generator,
  })  : _repository = repository ?? MathEntityRepository(),
        _generator = generator ?? MathQuestionGenerator();
  final MathEntityRepository _repository;
  final MathQuestionGenerator _generator;
  MathSessionMode _sessionMode = MathSessionMode.practice;
  int _examDurationMinutes = 15;
  int _secondsPerQuestion = 90;
  bool _loading = false;
  String _errorMessage = '';
  MathCountingQuestion? _question;
  int _score = 0;
  int _total = 0;
  int _traceQuestionOrdinal = 0;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  MathCountingQuestion? get question => _question;
  int get score => _score;
  int get total => _total;
  bool get isExamMode => _sessionMode == MathSessionMode.exam;
  bool get showScore => isExamMode;
  int get examDurationMinutes => _examDurationMinutes;
  int get secondsPerQuestion => _secondsPerQuestion;
  int get traceQuestionOrdinal => _traceQuestionOrdinal;
  int get expectedExamQuestionCount {
    final int safeSeconds = max(10, _secondsPerQuestion);
    return max(1, (_examDurationMinutes * 60) ~/ safeSeconds);
  }

  void setSessionMode(MathSessionMode mode) {
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
    setSessionMode(MathSessionMode.exam);
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
      _errorMessage = 'Không thể tải dữ liệu Toán tư duy: $e';
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
          'Chưa có vật đang bật. Hãy thêm hoặc bật vật ở màn quản lý.';
      notifyListeners();
      return;
    }
    _question = _generator.generateCountingQuestion(activeEntities);
    _traceQuestionOrdinal++;
    _errorMessage = '';
    notifyListeners();
  }

  bool submitAnswer(int selected) {
    final MathCountingQuestion? q = _question;
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
