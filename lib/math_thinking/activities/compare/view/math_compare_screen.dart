import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';
import 'package:location_app/study_tracking/math_trace_snapshot.dart';

import '../../../shared/ui/math_activity_graded_feedback_overlay.dart';
import '../../../shared/ui/math_activity_dialogs.dart';
import '../../../shared/ui/math_activity_ui_controller.dart';
import '../../../shared/view/math_entity_image_widget.dart';
import '../../../shared/view/math_entity_manager_screen.dart';
import '../model/math_compare_question.dart';
import '../view_model/math_compare_view_model.dart';

class MathCompareScreen extends StatefulWidget {
  const MathCompareScreen({super.key});

  @override
  State<MathCompareScreen> createState() => _MathCompareScreenState();
}

class _MathCompareScreenState extends State<MathCompareScreen> {
  late final MathCompareViewModel _viewModel = MathCompareViewModel();
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

  String _relationLabel(MathCompareRelation relation) {
    switch (relation) {
      case MathCompareRelation.more:
        return '>';
      case MathCompareRelation.less:
        return '<';
      case MathCompareRelation.equal:
        return '=';
    }
  }

  Future<void> _submitAnswer(MathCompareRelation selected) async {
    await _ui.runGradedAnswerFlow(
      context: context,
      submitAndReturnCorrect: () => _viewModel.submitAnswer(selected),
      isExamMode: _viewModel.isExamMode,
      total: _viewModel.total,
      expectedExamQuestionCount: _viewModel.expectedExamQuestionCount,
      onNextQuestion: () => _viewModel.nextQuestion(),
      onShowExamResult: _showExamResultDialog,
      buildMathGradedSnapshotJson: (bool correct) {
        final MathCompareQuestion? q = _viewModel.question;
        if (q == null) {
          return null;
        }
        return MathTraceSnapshot.compare(
          activityType: MathActivityType.compareMoreLessEqual,
          isCorrect: correct,
          questionOrdinal: _viewModel.traceQuestionOrdinal,
          question: q,
          userRelation: selected,
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
        _viewModel.setSessionMode(MathCompareSessionMode.practice);
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

  Future<void> _onBackRequested() async {
    await _ui.confirmExitIfUnlocked(context);
  }

  Widget _buildSideGroup({
    required int count,
    required dynamic entity,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.35),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: List<Widget>.generate(
                    count,
                    (int index) =>
                        MathEntityImageWidget(entity: entity, size: 48),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final MathCompareQuestion? question = _viewModel.question;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        unawaited(_onBackRequested());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.mathActCompareTitle),
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
                                textAlign: TextAlign.center),
                          )
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
                                  const SizedBox(height: 12),
                                  Text(
                                    l.mathCompareInstruction,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        _buildSideGroup(
                                          count: question.leftCount,
                                          entity: question.leftEntity,
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          width: 72,
                                          height: 72,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHigh,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w900),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        _buildSideGroup(
                                          count: question.rightCount,
                                          entity: question.rightEntity,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  ...question.options.map(
                                    (MathCompareRelation option) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          minimumSize:
                                              const Size.fromHeight(72),
                                          textStyle: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        onPressed: () =>
                                            unawaited(_submitAnswer(option)),
                                        child: Text(_relationLabel(option)),
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
