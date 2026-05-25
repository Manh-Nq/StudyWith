import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/language_study/data/language_study_dictionary_repository.dart';
import 'package:location_app/language_study/data/language_study_learned_words_store.dart';
import 'package:location_app/language_study/model/language_pair_id.dart';
import 'package:location_app/language_study/model/language_study_quiz_question.dart';
import 'package:location_app/language_study/service/language_study_quiz_generator.dart';
import 'package:location_app/language_study/service/language_study_tts_service.dart';
import 'package:location_app/study_tracking/language_study_trace_snapshot.dart';
import 'package:location_app/study_tracking/study_session_recorder.dart';
import 'package:location_app/study_tracking/study_subject_keys.dart';

import 'language_study_ui_controller.dart';

/// Kiểm tra: từng từ, chọn nghĩa đúng, Next — lưu vào Theo dõi.
class LanguageStudyReviewQuizScreen extends StatefulWidget {
  const LanguageStudyReviewQuizScreen({
    super.key,
    required this.pair,
  });

  final LanguagePairId pair;

  @override
  State<LanguageStudyReviewQuizScreen> createState() =>
      _LanguageStudyReviewQuizScreenState();
}

class _LanguageStudyReviewQuizScreenState extends State<LanguageStudyReviewQuizScreen> {
  static const int _sessionSize = 20;

  final LanguageStudyUiController _ui = LanguageStudyUiController();
  late final LanguageStudyDictionaryRepository _repo = widget.pair.createRepository();

  bool _busy = true;
  String? _error;
  List<LanguageStudyQuizQuestion> _questions = <LanguageStudyQuizQuestion>[];
  int _index = 0;
  int? _selectedChoiceIndex;
  bool _answered = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _ui.addListener(_onUi);
    unawaited(_bootstrap());
  }

  void _onUi() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _bootstrap() async {
    await StudySessionRecorder.instance.enterSubject(StudySubjectKeys.languageStudyEnVi);
    await _load();
  }

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _repo.warmUp();
      await LanguageStudyTtsService.instance.ensureReady();
      final Set<int> learned =
          await LanguageStudyLearnedWordsStore.instance.getLearnedWordIds(
        widget.pair,
      );
      if (learned.isEmpty) {
        if (mounted) {
          setState(() {
            _questions = <LanguageStudyQuizQuestion>[];
            _busy = false;
          });
        }
        return;
      }
      final List<int> pool = learned.toList()..shuffle(Random());
      final List<int> pick =
          pool.take(_sessionSize.clamp(0, pool.length)).toList();
      final items = await _repo.listItemsByWordIds(pick);
      final List<LanguageStudyQuizQuestion> questions =
          LanguageStudyQuizGenerator.fromListItems(items);
      if (mounted) {
        setState(() {
          _questions = questions;
          _busy = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _busy = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _ui.removeListener(_onUi);
    _ui.dispose();
    unawaited(LanguageStudyTtsService.instance.stop());
    unawaited(
      StudySessionRecorder.instance.leaveSubject(StudySubjectKeys.languageStudyEnVi),
    );
    super.dispose();
  }

  Future<void> _onWillPop() async {
    await _ui.confirmExitIfUnlocked(context);
  }

  LanguageStudyQuizQuestion? get _current {
    if (_index < 0 || _index >= _questions.length) {
      return null;
    }
    return _questions[_index];
  }

  Future<void> _speakCurrent() async {
    final LanguageStudyQuizQuestion? q = _current;
    if (q == null || _ui.screenLocked) {
      if (_ui.screenLocked) {
        _ui.showLockedSnack(context);
      }
      return;
    }
    await LanguageStudyTtsService.instance.speakEnglish(q.headword);
  }

  void _pickChoice(int choiceIndex) {
    if (_answered || _ui.screenLocked) {
      if (_ui.screenLocked) {
        _ui.showLockedSnack(context);
      }
      return;
    }
    final LanguageStudyQuizQuestion? q = _current;
    if (q == null) {
      return;
    }
    final bool ok = choiceIndex == q.correctChoiceIndex;
    setState(() {
      _selectedChoiceIndex = choiceIndex;
      _answered = true;
      if (ok) {
        _correctCount += 1;
      }
    });
    StudySessionRecorder.instance.recordGradedAnswer(
      isCorrect: ok,
      gradedSnapshotJson: LanguageStudyTraceSnapshot.meaningChoice(
        pairId: widget.pair.name,
        questionOrdinal: _index + 1,
        isCorrect: ok,
        question: q,
        userChoice: q.choices[choiceIndex],
        userChoiceIndex: choiceIndex,
      ),
    );
  }

  Future<void> _next() async {
    if (!_answered) {
      return;
    }
    if (_index + 1 >= _questions.length) {
      await _showSummaryAndPop();
      return;
    }
    setState(() {
      _index += 1;
      _selectedChoiceIndex = null;
      _answered = false;
    });
  }

  Future<void> _showSummaryAndPop() async {
    final AppLocalizations l = AppLocalizations.of(context)!;
    if (!mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(l.languageStudyQuizDoneTitle),
        content: Text(
          l.languageStudyQuizDoneBody(_correctCount, _questions.length),
        ),
        actions: <Widget>[
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.mathDialogOk),
          ),
        ],
      ),
    );
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final LanguageStudyQuizQuestion? q = _current;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          unawaited(_onWillPop());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.languageStudyReview20AppBar),
          actions: <Widget>[
            IconButton(
              tooltip: l.languageStudyLockScreenTitle,
              onPressed: () => unawaited(_ui.toggleScreenLock(context, l)),
              icon: Icon(
                _ui.screenLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
              ),
            ),
          ],
        ),
        body: _busy
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        '${l.languageStudyDbError}\n$_error',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  )
                : _questions.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l.languageStudyReviewEmpty,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      )
                    : q == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  l.languageStudyQuizProgress(_index + 1, _questions.length),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                Material(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: () => unawaited(_speakCurrent()),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                q.headword,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                Icons.volume_up_rounded,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ],
                                          ),
                                          if (q.ipaPreview != null &&
                                              q.ipaPreview!.trim().isNotEmpty) ...<Widget>[
                                            const SizedBox(height: 8),
                                            Text(
                                              q.ipaPreview!.trim(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                          Text(
                                            l.languageStudyQuizPickMeaning,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: q.choices.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (BuildContext context, int i) {
                                      final String label = q.choices[i];
                                      final bool selected = _selectedChoiceIndex == i;
                                      final bool isCorrect = i == q.correctChoiceIndex;
                                      Color? bg;
                                      Color? border;
                                      if (_answered) {
                                        if (isCorrect) {
                                          bg = Colors.green.shade50;
                                          border = Colors.green;
                                        } else if (selected) {
                                          bg = Colors.red.shade50;
                                          border = Colors.red;
                                        }
                                      }
                                      return OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(56),
                                          backgroundColor: bg,
                                          side: BorderSide(
                                            color: border ?? Colors.grey.shade400,
                                            width: _answered && (selected || isCorrect) ? 2 : 1,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: _answered ? null : () => _pickChoice(i),
                                        child: Text(
                                          label,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FilledButton(
                                  onPressed: _answered ? () => unawaited(_next()) : null,
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size.fromHeight(52),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  child: Text(
                                    _index + 1 >= _questions.length
                                        ? l.languageStudyQuizFinish
                                        : l.languageStudyQuizNext,
                                  ),
                                ),
                              ],
                            ),
                          ),
      ),
    );
  }
}
