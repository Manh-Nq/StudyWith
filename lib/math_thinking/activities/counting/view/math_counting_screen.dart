import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';
import 'package:location_app/study_tracking/math_trace_snapshot.dart';

import '../../../shared/ui/math_activity_graded_feedback_overlay.dart';
import '../model/math_counting_question.dart';
import '../../../shared/ui/math_activity_dialogs.dart';
import '../../../shared/ui/math_activity_ui_controller.dart';
import '../../../shared/view/math_entity_image_widget.dart';
import '../../../shared/view/math_entity_manager_screen.dart';
import '../view_model/math_counting_view_model.dart';

class MathCountingScreen extends StatefulWidget {
  const MathCountingScreen({super.key});

  @override
  State<MathCountingScreen> createState() => _MathCountingScreenState();
}

class _MathCountingScreenState extends State<MathCountingScreen> {
  late final MathCountingViewModel _viewModel = MathCountingViewModel();
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
        final MathCountingQuestion? q = _viewModel.question;
        if (q == null) {
          return null;
        }
        return MathTraceSnapshot.counting(
          activityType: MathActivityType.countingSelectAnswer,
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
        _viewModel.setSessionMode(MathSessionMode.practice);
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

  Future<bool> _onWillPop() async {
    await _confirmExitAndBack();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final question = _viewModel.question;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        unawaited(_onWillPop());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.mathCountingScreenTitle),
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
            IconButton(
              tooltip: l.mathTooltipManageObjects,
              onPressed: _ui.screenLocked
                  ? () => _ui.showLockedSnack(context)
                  : () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext ctx) =>
                              const MathEntityManagerScreen(),
                        ),
                      );
                      await _viewModel.nextQuestion();
                    },
              icon: const Icon(Icons.settings_rounded),
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
                        ? Center(
                            child: Text(_viewModel.errorMessage,
                                textAlign: TextAlign.center))
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
                                            fontWeight: FontWeight.w800,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  if (_viewModel.isExamMode)
                                    const SizedBox(height: 8),
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
                                  if (_viewModel.showScore)
                                    const SizedBox(height: 12),
                                  Text(
                                    l.mathCountingQuestionHowMany(
                                      question.entityType.name,
                                    ),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest
                                            .withValues(alpha: 0.3),
                                      ),
                                      child: Wrap(
                                        spacing: 14,
                                        runSpacing: 14,
                                        alignment: WrapAlignment.center,
                                        runAlignment: WrapAlignment.center,
                                        children: List<Widget>.generate(
                                          question.correctAnswer,
                                          (int index) => MathEntityImageWidget(
                                            entity: question.entityType,
                                            size: 64,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            minimumSize:
                                                const Size.fromHeight(92),
                                            textStyle: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          onPressed: () => unawaited(
                                              _submitAnswer(
                                                  question.options[0])),
                                          child: Text(
                                              question.options[0].toString()),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            minimumSize:
                                                const Size.fromHeight(92),
                                            textStyle: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          onPressed: () => unawaited(
                                              _submitAnswer(
                                                  question.options[1])),
                                          child: Text(
                                              question.options[1].toString()),
                                        ),
                                      ),
                                    ],
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
