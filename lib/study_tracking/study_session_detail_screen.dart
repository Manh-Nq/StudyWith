import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/l10n/math_activity_l10n.dart';
import 'package:location_app/math_thinking/activities/sort/model/math_sort_question.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';
import 'package:location_app/math_thinking/shared/model/math_entity_type.dart';
import 'package:location_app/math_thinking/shared/view/math_entity_image_widget.dart';

import 'language_study_trace_snapshot.dart';
import 'math_trace_snapshot.dart';
import 'study_session_repository.dart';

/// Xem lại chi tiết từng câu đã làm trong một phiên (chỉ đọc).
class StudySessionDetailScreen extends StatefulWidget {
  const StudySessionDetailScreen({super.key, required this.session});

  final StudySessionRow session;

  @override
  State<StudySessionDetailScreen> createState() =>
      _StudySessionDetailScreenState();
}

class _StudySessionDetailScreenState extends State<StudySessionDetailScreen> {
  List<StudySessionGradedAttemptRow> _attempts = <StudySessionGradedAttemptRow>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<StudySessionGradedAttemptRow> rows =
        await StudySessionRepository.instance
            .queryGradedAttempts(widget.session.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _attempts = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.studySessionDetailTitle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _attempts.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l.studySessionDetailEmptyAttempts,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: _attempts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int i) {
                    final StudySessionGradedAttemptRow row = _attempts[i];
                    return _GradedAttemptListTile(
                      listIndexFallback: i + 1,
                      snapshotJson: row.snapshotJson,
                      l: l,
                    );
                  },
                ),
    );
  }
}

/// Màn chỉ đọc: toàn bộ nội dung câu như lúc làm bài (không tương tác).
/// [listIndexFallback]: thứ tự câu/lần làm trong phiên (1, 2, 3… theo DB).
class StudySessionGradedAttemptDetailScreen extends StatelessWidget {
  const StudySessionGradedAttemptDetailScreen({
    super.key,
    required this.snapshotJson,
    required this.listIndexFallback,
  });

  final String snapshotJson;
  final int listIndexFallback;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final int displayN = listIndexFallback;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.studySessionDetailQuestionIndex(displayN)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: _GradedAttemptFullReview(
          displayQuestionOrdinal: displayN,
          snapshotJson: snapshotJson,
          l: l,
        ),
      ),
    );
  }
}

class _GradedAttemptListTile extends StatelessWidget {
  const _GradedAttemptListTile({
    required this.listIndexFallback,
    required this.snapshotJson,
    required this.l,
  });

  final int listIndexFallback;
  final String snapshotJson;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final Map<String, Object?> root = _unwrapAny(snapshotJson);
    // Thứ tự theo phiên học (insert), không dùng questionOrdinal trong snapshot:
    // mỗi dạng toán reset 1..n; trả lời sai rồi đúng lại trùng số câu.
    final int displayOrdinal = listIndexFallback;
    final bool ok = _parseIsCorrect(root);
    final ThemeData theme = Theme.of(context);
    final String activityTitle = _activityTitle(l, root);
    final String resultLine =
        ok ? l.studySessionDetailCorrectLabel : l.studySessionDetailWrongLabel;
    return Card(
      child: ListTile(
        isThreeLine: true,
        leading: Icon(
          ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: ok ? Colors.green : Colors.red,
          size: 32,
        ),
        title: Text(
          l.studySessionDetailQuestionIndex(displayOrdinal),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${l.studySessionDetailActivityType}: $activityTitle\n$resultLine',
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext ctx) => StudySessionGradedAttemptDetailScreen(
                listIndexFallback: listIndexFallback,
                snapshotJson: snapshotJson,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GradedAttemptFullReview extends StatelessWidget {
  const _GradedAttemptFullReview({
    required this.displayQuestionOrdinal,
    required this.snapshotJson,
    required this.l,
  });

  final int displayQuestionOrdinal;
  final String snapshotJson;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final Map<String, Object?> root = _unwrapAny(snapshotJson);
    final bool ok = _parseIsCorrect(root);
    final Map<String, Object?> p = _payloadMap(root);
    final String kind = (p['kind'] as String?) ?? '';
    final ThemeData theme = Theme.of(context);
    final String activityTitle = _activityTitle(l, root);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    l.studySessionDetailQuestionIndex(displayQuestionOrdinal),
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                Icon(
                  ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: ok ? Colors.green : Colors.red,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${l.studySessionDetailActivityType}: $activityTitle',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              ok ? l.studySessionDetailCorrectLabel : l.studySessionDetailWrongLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: ok ? Colors.green.shade800 : Colors.red.shade800,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Divider(height: 20),
            _buildPayload(context, kind, p),
          ],
        ),
      ),
    );
  }

  Widget _buildPayload(
    BuildContext context,
    String kind,
    Map<String, Object?> p,
  ) {
    switch (kind) {
      case 'counting':
        return _CountingReadOnly(l: l, p: p);
      case 'compare':
        return _CompareReadOnly(l: l, p: p);
      case 'sequence':
        return _SequenceReadOnly(l: l, p: p);
      case 'sort':
        return _SortReadOnly(l: l, p: p);
      case 'addSub':
        return _AddSubReadOnly(l: l, p: p);
      case 'choice':
        return _ChoiceReadOnly(l: l, p: p);
      case 'meaningChoice':
        return _LanguageMeaningChoiceReadOnly(l: l, p: p);
      default:
        return Text(
          p.toString(),
          style: Theme.of(context).textTheme.bodySmall,
        );
    }
  }
}

class _CountingReadOnly extends StatelessWidget {
  const _CountingReadOnly({required this.l, required this.p});
  final AppLocalizations l;
  final Map<String, Object?> p;

  @override
  Widget build(BuildContext context) {
    final Map<String, Object?> em =
        (p['entity'] as Map?)?.cast<String, Object?>() ?? <String, Object?>{};
    final MathEntityType entity = MathTraceSnapshot.entityFromJson(em);
    final List<int> options = _intList(p['options']);
    final int user = (p['userAnswer'] as num?)?.toInt() ?? 0;
    final int correct = (p['correctAnswer'] as num?)?.toInt() ?? 0;
    final int displayCount =
        correct > 0 ? correct : (options.isNotEmpty ? options.reduce(_maxInt) : 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l.mathCountingQuestionHowMany(entity.name),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List<Widget>.generate(
            displayCount,
            (_) => MathEntityImageWidget(entity: entity, size: 56),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _answerLine(
                context,
                l.studySessionDetailYourAnswer,
                '$user',
              ),
            ),
            Expanded(
              child: _answerLine(
                context,
                l.studySessionDetailCorrectAnswer,
                '$correct',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: options
              .map(
                (int o) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _fakeOptionChip(
                      context,
                      label: '$o',
                      highlight: o == user || o == correct,
                      isUser: o == user,
                      isCorrect: o == correct,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

int _maxInt(int a, int b) => a > b ? a : b;

class _CompareReadOnly extends StatelessWidget {
  const _CompareReadOnly({required this.l, required this.p});
  final AppLocalizations l;
  final Map<String, Object?> p;

  @override
  Widget build(BuildContext context) {
    final MathEntityType left = MathTraceSnapshot.entityFromJson(
      (p['leftEntity'] as Map?)?.cast<String, Object?>() ?? <String, Object?>{},
    );
    final MathEntityType right = MathTraceSnapshot.entityFromJson(
      (p['rightEntity'] as Map?)?.cast<String, Object?>() ?? <String, Object?>{},
    );
    final int lc = (p['leftCount'] as num?)?.toInt() ?? 0;
    final int rc = (p['rightCount'] as num?)?.toInt() ?? 0;
    final String userRel = (p['userRelation'] as String?) ?? '';
    final String corRel = (p['correctRelation'] as String?) ?? '';
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: _entityGroup(left, lc)),
            SizedBox(
              width: 48,
              child: Text(
                '?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            Expanded(child: _entityGroup(right, rc)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _answerLine(
                context,
                l.studySessionDetailYourAnswer,
                _relationLabel(l, userRel),
              ),
            ),
            Expanded(
              child: _answerLine(
                context,
                l.studySessionDetailCorrectAnswer,
                _relationLabel(l, corRel),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _entityGroup(MathEntityType e, int count) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: List<Widget>.generate(
          count,
          (_) => MathEntityImageWidget(entity: e, size: 44),
        ),
      ),
    );
  }

  String _relationLabel(AppLocalizations l, String name) {
    switch (name) {
      case 'more':
        return l.studySessionDetailRelationMore;
      case 'less':
        return l.studySessionDetailRelationLess;
      case 'equal':
        return l.studySessionDetailRelationEqual;
      default:
        return name;
    }
  }
}

class _SequenceReadOnly extends StatelessWidget {
  const _SequenceReadOnly({required this.l, required this.p});
  final AppLocalizations l;
  final Map<String, Object?> p;

  @override
  Widget build(BuildContext context) {
    final List<Object?> raw = (p['sequence'] as List?) ?? const <Object?>[];
    final List<int?> seq = raw.map((Object? e) {
      if (e == null) {
        return null;
      }
      if (e is num) {
        return e.toInt();
      }
      return int.tryParse(e.toString());
    }).toList();
    final List<int> options = _intList(p['options']);
    final int user = (p['userAnswer'] as num?)?.toInt() ?? 0;
    final int correct = (p['correctAnswer'] as num?)?.toInt() ?? 0;
    return Column(
      children: <Widget>[
        Wrap(
          spacing: 8,
          children: seq
              .map(
                (int? v) => Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Text(
                    v?.toString() ?? '?',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _answerLine(
                context,
                l.studySessionDetailYourAnswer,
                '$user',
              ),
            ),
            Expanded(
              child: _answerLine(
                context,
                l.studySessionDetailCorrectAnswer,
                '$correct',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options
              .map(
                (int o) => _fakeOptionChip(
                  context,
                  label: '$o',
                  highlight: o == user || o == correct,
                  isUser: o == user,
                  isCorrect: o == correct,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SortReadOnly extends StatelessWidget {
  const _SortReadOnly({required this.l, required this.p});
  final AppLocalizations l;
  final Map<String, Object?> p;

  @override
  Widget build(BuildContext context) {
    final List<int> unsorted = _intList(p['unsorted']);
    final String dir = (p['direction'] as String?) ?? '';
    final String user = (p['userOption'] as String?) ?? '';
    final String cor = (p['correctAnswerText'] as String?) ?? '';
    final String dirLabel = dir == MathSortDirection.descending.name
        ? l.studySessionDetailSortDescending
        : l.studySessionDetailSortAscending;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          dirLabel,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: Text(
            unsorted.join(', '),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 12),
        _answerLine(context, l.studySessionDetailYourAnswer, user),
        const SizedBox(height: 6),
        _answerLine(context, l.studySessionDetailCorrectAnswer, cor),
      ],
    );
  }
}

class _AddSubReadOnly extends StatelessWidget {
  const _AddSubReadOnly({required this.l, required this.p});
  final AppLocalizations l;
  final Map<String, Object?> p;

  @override
  Widget build(BuildContext context) {
    final int left = (p['left'] as num?)?.toInt() ?? 0;
    final int right = (p['right'] as num?)?.toInt() ?? 0;
    final String op = (p['operator'] as String?) == 'subtract' ? '−' : '+';
    final List<int> options = _intList(p['options']);
    final int user = (p['userAnswer'] as num?)?.toInt() ?? 0;
    final int correct = (p['correctAnswer'] as num?)?.toInt() ?? 0;
    return Column(
      children: <Widget>[
        Text(
          '$left $op $right = ?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _answerLine(
                context,
                l.studySessionDetailYourAnswer,
                '$user',
              ),
            ),
            Expanded(
              child: _answerLine(
                context,
                l.studySessionDetailCorrectAnswer,
                '$correct',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options
              .map(
                (int o) => _fakeOptionChip(
                  context,
                  label: '$o',
                  highlight: o == user || o == correct,
                  isUser: o == user,
                  isCorrect: o == correct,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ChoiceReadOnly extends StatelessWidget {
  const _ChoiceReadOnly({required this.l, required this.p});
  final AppLocalizations l;
  final Map<String, Object?> p;

  @override
  Widget build(BuildContext context) {
    final String title = (p['screenTitle'] as String?) ?? '';
    final String qText = (p['questionText'] as String?) ?? '';
    final String hint = (p['hintText'] as String?) ?? '';
    final List<String> options = ((p['options'] as List?) ?? const <Object?>[])
        .map((Object? e) => e?.toString() ?? '')
        .toList();
    final int userI = (p['userIndex'] as num?)?.toInt() ?? -1;
    final int corI = (p['correctIndex'] as num?)?.toInt() ?? -1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (title.isNotEmpty)
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        if (title.isNotEmpty) const SizedBox(height: 6),
        Text(
          qText,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        if (hint.isNotEmpty) ...<Widget>[
          const SizedBox(height: 6),
          Text(hint, style: Theme.of(context).textTheme.bodyMedium),
        ],
        const SizedBox(height: 10),
        ...List<Widget>.generate(options.length, (int i) {
          final String opt = options[i];
          final bool isUser = i == userI;
          final bool isCor = i == corI;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _fakeOptionChip(
              context,
              label: opt,
              highlight: isUser || isCor,
              isUser: isUser,
              isCorrect: isCor,
            ),
          );
        }),
      ],
    );
  }
}

Widget _answerLine(BuildContext context, String label, String value) {
  final TextStyle base =
      Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 15);
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text.rich(
      TextSpan(
        style: base.copyWith(color: Theme.of(context).colorScheme.onSurface),
        children: <TextSpan>[
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

Widget _fakeOptionChip(
  BuildContext context, {
  required String label,
  required bool highlight,
  required bool isUser,
  required bool isCorrect,
}) {
  Color border = Colors.grey.shade400;
  Color bg = Colors.grey.shade100;
  if (isCorrect) {
    border = Colors.green;
    bg = Colors.green.shade50;
  } else if (isUser && !isCorrect) {
    border = Colors.red;
    bg = Colors.red.shade50;
  } else if (highlight) {
    border = Colors.blue;
    bg = Colors.blue.shade50;
  }
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: border, width: 2),
    ),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
    ),
  );
}

Map<String, Object?> _unwrapAny(String json) {
  final Map<String, Object?> root = MathTraceSnapshot.unwrap(json);
  if (LanguageStudyTraceSnapshot.isLanguageStudy(root)) {
    return root;
  }
  return root;
}

bool _parseIsCorrect(Map<String, Object?> root) {
  return LanguageStudyTraceSnapshot.isLanguageStudy(root)
      ? LanguageStudyTraceSnapshot.parseIsCorrect(root)
      : MathTraceSnapshot.parseIsCorrect(root);
}

Map<String, Object?> _payloadMap(Map<String, Object?> root) {
  return LanguageStudyTraceSnapshot.isLanguageStudy(root)
      ? LanguageStudyTraceSnapshot.payloadMap(root)
      : MathTraceSnapshot.payloadMap(root);
}

String _activityTitle(AppLocalizations l, Map<String, Object?> root) {
  if (LanguageStudyTraceSnapshot.isLanguageStudy(root)) {
    return l.languageStudyReview20AppBar;
  }
  final MathActivityType? act = MathTraceSnapshot.parseActivityType(root);
  return act != null
      ? MathActivityL10n.title(l, act)
      : (root['mathActivityType']?.toString() ?? '');
}

class _LanguageMeaningChoiceReadOnly extends StatelessWidget {
  const _LanguageMeaningChoiceReadOnly({required this.l, required this.p});
  final AppLocalizations l;
  final Map<String, Object?> p;

  @override
  Widget build(BuildContext context) {
    final String headword = (p['headword'] as String?) ?? '';
    final String? ipa = p['ipa'] as String?;
    final String correct = (p['correctMeaning'] as String?) ?? '';
    final String user = (p['userChoice'] as String?) ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          headword,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        if (ipa != null && ipa.trim().isNotEmpty) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            ipa.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
        const SizedBox(height: 12),
        _answerLine(context, l.studySessionDetailYourAnswer, user),
        const SizedBox(height: 6),
        _answerLine(context, l.studySessionDetailCorrectAnswer, correct),
      ],
    );
  }
}

List<int> _intList(Object? raw) {
  if (raw is! List) {
    return <int>[];
  }
  return raw
      .map((Object? e) => e is num ? e.toInt() : int.tryParse('$e') ?? 0)
      .toList();
}
