import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';
import 'package:location_app/study_tracking/math_trace_snapshot.dart';

import '../../../shared/ui/math_activity_graded_feedback_overlay.dart';
import '../../../shared/ui/math_activity_dialogs.dart';
import '../../../shared/ui/math_activity_ui_controller.dart';
import '../../../shared/view/math_entity_manager_screen.dart';
import '../model/math_choice_question.dart';
import '../view_model/math_choice_activity_view_model.dart';

typedef MathChoiceBodyBuilder = Widget Function(
  BuildContext context,
  MathChoiceQuestion question,
);

typedef MathChoiceOptionLabelBuilder = String Function(
  BuildContext context,
  int index,
  String optionValue,
);

class MathChoiceActivityScreen extends StatefulWidget {
  const MathChoiceActivityScreen({
    super.key,
    required this.title,
    required this.traceActivityType,
    required this.viewModel,
    required this.bodyBuilder,
    this.optionLabelBuilder,
    this.showEntityManagerButton = false,
  });
  final String title;
  final MathActivityType traceActivityType;
  final MathChoiceActivityViewModel viewModel;
  final MathChoiceBodyBuilder bodyBuilder;
  final MathChoiceOptionLabelBuilder? optionLabelBuilder;
  final bool showEntityManagerButton;

  @override
  State<MathChoiceActivityScreen> createState() =>
      _MathChoiceActivityScreenState();
}

class _MathChoiceActivityScreenState extends State<MathChoiceActivityScreen> {
  final MathActivityUiController _ui = MathActivityUiController();

  MathChoiceActivityViewModel get _viewModel => widget.viewModel;

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

  Future<void> _submitAnswer(int index) async {
    await _ui.runGradedAnswerFlow(
      context: context,
      submitAndReturnCorrect: () => _viewModel.submitAnswer(index),
      isExamMode: _viewModel.isExamMode,
      total: _viewModel.total,
      expectedExamQuestionCount: _viewModel.expectedExamQuestionCount,
      onNextQuestion: () => _viewModel.nextQuestion(),
      onShowExamResult: _showExamResultDialog,
      buildMathGradedSnapshotJson: (bool correct) {
        final MathChoiceQuestion? q = _viewModel.question;
        if (q == null) {
          return null;
        }
        return MathTraceSnapshot.choice(
          activityType: widget.traceActivityType,
          isCorrect: correct,
          questionOrdinal: _viewModel.traceQuestionOrdinal,
          question: q,
          userIndex: index,
          screenTitle: widget.title,
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
        _viewModel.setSessionMode(MathChoiceSessionMode.practice);
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
    final MathChoiceQuestion? question = _viewModel.question;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          unawaited(_confirmExitAndBack());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
            if (widget.showEntityManagerButton)
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
                                  const SizedBox(height: 12),
                                  if (question.hintText.isNotEmpty)
                                    Text(
                                      question.hintText,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  if (question.hintText.isNotEmpty)
                                    const SizedBox(height: 12),
                                  Expanded(
                                    child:
                                        widget.bodyBuilder(context, question),
                                  ),
                                  const SizedBox(height: 12),
                                  ...List<Widget>.generate(
                                    question.options.length,
                                    (int i) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          minimumSize:
                                              const Size.fromHeight(72),
                                          textStyle: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        onPressed: () =>
                                            unawaited(_submitAnswer(i)),
                                        child: Text(
                                          widget.optionLabelBuilder?.call(
                                                context,
                                                i,
                                                question.options[i],
                                              ) ??
                                              question.options[i],
                                        ),
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
