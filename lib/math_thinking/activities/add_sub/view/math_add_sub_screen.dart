import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';
import 'package:location_app/study_tracking/math_trace_snapshot.dart';

import '../../../shared/ui/math_activity_graded_feedback_overlay.dart';
import '../../../shared/ui/math_activity_dialogs.dart';
import '../../../shared/ui/math_activity_ui_controller.dart';
import '../model/math_add_sub_question.dart';
import '../view_model/math_add_sub_view_model.dart';

class MathAddSubScreen extends StatefulWidget {
  const MathAddSubScreen({super.key});

  @override
  State<MathAddSubScreen> createState() => _MathAddSubScreenState();
}

class _MathAddSubScreenState extends State<MathAddSubScreen> {
  late final MathAddSubViewModel _viewModel = MathAddSubViewModel();
  final MathActivityUiController _ui = MathActivityUiController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _ui.addListener(_onUiChanged);
    unawaited(_viewModel.initialize());
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onUiChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _ui.removeListener(_onUiChanged);
    _ui.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer(int selected) async {
    await _ui.runGradedAnswerFlow(
      context: context,
      submitAndReturnCorrect: () => _viewModel.submitAnswer(selected),
      isExamMode: _viewModel.isExamMode,
      total: _viewModel.total,
      expectedExamQuestionCount: _viewModel.expectedExamQuestionCount,
      onNextQuestion: () => _viewModel.nextQuestion(),
      onShowExamResult: _showExamResultDialog,
      buildMathGradedSnapshotJson: (bool correct) {
        final MathAddSubQuestion? q = _viewModel.question;
        if (q == null) {
          return null;
        }
        return MathTraceSnapshot.addSub(
          activityType: MathActivityType.addSubtractRange,
          isCorrect: correct,
          questionOrdinal: _viewModel.traceQuestionOrdinal,
          question: q,
          userAnswer: selected,
        );
      },
    );
  }

  Future<void> _showExamResultDialog(BuildContext dialogContext) async {
    await MathActivityDialogs.showExamResult(
      dialogContext,
      score: _viewModel.score,
      expectedTotal: _viewModel.expectedExamQuestionCount,
      onRetryExam: () async {
        _viewModel.configureExam(
          durationMinutes: _viewModel.examDurationMinutes,
          secondsPerQuestion: _viewModel.secondsPerQuestion,
        );
        await _viewModel.nextQuestion();
      },
      onBackToPractice: () async {
        _viewModel.setSessionMode(MathAddSubSessionMode.practice);
        await _viewModel.nextQuestion();
      },
    );
  }

  Future<void> _showExamSetupDialog() async {
    await _ui.openExamSetupIfUnlocked(
      context: context,
      initialDurationMinutes: _viewModel.examDurationMinutes,
      initialSecondsPerQuestion: _viewModel.secondsPerQuestion,
      onConfirmed: (int duration, int secondsPerQuestion) async {
        _viewModel.configureExam(
          durationMinutes: duration,
          secondsPerQuestion: secondsPerQuestion,
        );
        await _viewModel.nextQuestion();
      },
    );
  }

  Future<void> _confirmExitAndBack() async {
    await _ui.confirmExitIfUnlocked(context);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final MathAddSubQuestion? question = _viewModel.question;
    final String op =
        question?.operatorType == MathAddSubOperator.subtract ? '-' : '+';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          unawaited(_confirmExitAndBack());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.mathActAddSubTitle),
          actions: <Widget>[
            IconButton(
              tooltip: l.mathTooltipOpenExam,
              onPressed: _ui.screenLocked
                  ? () => _ui.showLockedSnack(context)
                  : () => unawaited(_showExamSetupDialog()),
              icon: const Icon(Icons.fact_check_rounded),
            ),
            IconButton(
              tooltip: _ui.screenLocked ? l.mathTooltipUnlock : l.mathTooltipLock,
              onPressed: () => unawaited(
                _ui.toggleScreenLock(context, l),
              ),
              icon: Icon(
                _ui.screenLocked
                    ? Icons.lock_open_rounded
                    : Icons.lock_rounded,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: _viewModel.loading
                    ? const Center(child: CircularProgressIndicator())
                    : _viewModel.errorMessage.isNotEmpty
                        ? Center(child: Text(_viewModel.errorMessage))
                        : question == null
                            ? Center(child: Text(l.mathNoQuestion))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  if (_viewModel.isExamMode)
                                    Text(
                                      l.mathExamModeBanner,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w800),
                                    ),
                                  if (_viewModel.showScore)
                                    Text(
                                      l.mathScoreRunning(
                                        _viewModel.score,
                                        _viewModel.total,
                                      ),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  const SizedBox(height: 14),
                                  Text(
                                    l.mathAddSubPickAnswer,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withValues(alpha: 0.35),
                                    ),
                                    child: Text(
                                      '${question.left} $op ${question.right} = ?',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 44,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...question.options.map(
                                    (int option) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          minimumSize:
                                              const Size.fromHeight(78),
                                          textStyle: const TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        onPressed: () =>
                                            unawaited(_submitAnswer(option)),
                                        child: Text(option.toString()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
              ),
              MathActivityGradedFeedbackOverlay(
                show: _ui.showFeedback,
                isCorrect: _ui.feedbackIsCorrect,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
