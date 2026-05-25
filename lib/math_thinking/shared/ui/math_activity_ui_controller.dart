import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/study_tracking/study_session_recorder.dart';

import '../service/math_answer_feedback_speech.dart';
import 'math_activity_dialogs.dart';

/// Trạng thái & luồng UI dùng chung: overlay đúng/sai, khóa câu trả lời, thi,
/// khóa màn hình, âm thanh phản hồi.
///
/// Gắn với `State` qua `addListener` + `setState` để rebuild; không gắn trực tiếp
/// vào từng [ChangeNotifier] bài học để tránh phụ thuộc kiểu session mode / VM.
class MathActivityUiController extends ChangeNotifier {
  bool showFeedback = false;
  bool feedbackIsCorrect = false;
  bool answerLocked = false;
  bool screenLocked = false;
  String screenLockPassword = '';

  static const Duration feedbackPause = Duration(seconds: 1);

  void showLockedSnack(BuildContext context) {
    if (!context.mounted) {
      return;
    }
    MathActivityDialogs.showScreenLockedSnack(context);
  }

  /// [submitAndReturnCorrect] được gọi sau khi đã bật [answerLocked] (tránh chạm đúp).
  /// [buildMathGradedSnapshotJson] trả về JSON (vd. [MathTraceSnapshot]) để lưu Theo dõi; có thể null.
  Future<void> runGradedAnswerFlow({
    required BuildContext context,
    required bool Function() submitAndReturnCorrect,
    required bool isExamMode,
    required int total,
    required int expectedExamQuestionCount,
    required Future<void> Function() onNextQuestion,
    required Future<void> Function(BuildContext dialogContext) onShowExamResult,
    String? Function(bool correct)? buildMathGradedSnapshotJson,
    Duration pause = feedbackPause,
  }) async {
    if (answerLocked) {
      return;
    }
    final String languageCode = Localizations.localeOf(context).languageCode;
    answerLocked = true;
    notifyListeners();
    final bool correct = submitAndReturnCorrect();
    final String? traceJson = buildMathGradedSnapshotJson?.call(correct);
    StudySessionRecorder.instance.recordGradedAnswer(
      isCorrect: correct,
      mathGradedSnapshotJson: traceJson,
    );
    if (!context.mounted) {
      answerLocked = false;
      notifyListeners();
      return;
    }
    feedbackIsCorrect = correct;
    showFeedback = true;
    notifyListeners();
    unawaited(
      MathAnswerFeedbackSpeech.instance.speakForAnswer(
        correct,
        languageCode: languageCode,
      ),
    );
    final bool examCompleted =
        isExamMode && total >= expectedExamQuestionCount;
    if (examCompleted) {
      await Future<void>.delayed(pause);
      if (!context.mounted) {
        answerLocked = false;
        notifyListeners();
        return;
      }
      showFeedback = false;
      notifyListeners();
      await onShowExamResult(context);
      if (!context.mounted) {
        answerLocked = false;
        notifyListeners();
        return;
      }
      answerLocked = false;
      notifyListeners();
      return;
    }
    if (correct || isExamMode) {
      await Future<void>.delayed(pause);
      await onNextQuestion();
    } else {
      await Future<void>.delayed(pause);
    }
    if (!context.mounted) {
      answerLocked = false;
      notifyListeners();
      return;
    }
    showFeedback = false;
    answerLocked = false;
    notifyListeners();
  }

  Future<void> openExamSetupIfUnlocked({
    required BuildContext context,
    required int initialDurationMinutes,
    required int initialSecondsPerQuestion,
    required Future<void> Function(int durationMinutes, int secondsPerQuestion)
        onConfirmed,
  }) async {
    if (screenLocked) {
      showLockedSnack(context);
      return;
    }
    await MathActivityDialogs.showExamSetup(
      context,
      initialDurationMinutes: initialDurationMinutes,
      initialSecondsPerQuestion: initialSecondsPerQuestion,
      onConfirmed: onConfirmed,
    );
  }

  Future<void> toggleScreenLock(
    BuildContext context,
    AppLocalizations l,
  ) async {
    if (screenLocked) {
      final String? pass = await MathActivityDialogs.showPasswordDialog(
        context,
        title: l.mathUnlockTitle,
        confirmLabel: l.mathDialogUnlock,
      );
      if (!context.mounted || pass == null) {
        return;
      }
      if (pass == screenLockPassword) {
        screenLocked = false;
        screenLockPassword = '';
        notifyListeners();
      } else {
        MathActivityDialogs.showWrongPasswordSnack(context);
      }
      return;
    }
    final String? pass = await MathActivityDialogs.showPasswordDialog(
      context,
      title: l.mathLockMathScreenTitle,
      confirmLabel: l.mathDialogLock,
    );
    if (!context.mounted || pass == null) {
      return;
    }
    screenLockPassword = pass;
    screenLocked = true;
    notifyListeners();
    showLockedSnack(context);
  }

  Future<void> confirmExitIfUnlocked(BuildContext context) async {
    if (screenLocked) {
      showLockedSnack(context);
      return;
    }
    final bool? ok = await MathActivityDialogs.showExitConfirm(context);
    if (ok == true && context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
