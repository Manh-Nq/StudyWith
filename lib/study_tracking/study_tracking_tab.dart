import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';

import 'package:location_app/theme/kid_friendly_theme.dart';

import 'study_session_detail_screen.dart';
import 'study_session_repository.dart';
import 'study_subject_visual.dart';

class StudyTrackingTab extends StatefulWidget {
  const StudyTrackingTab({super.key});

  @override
  State<StudyTrackingTab> createState() => _StudyTrackingTabState();
}

class _StudyTrackingTabState extends State<StudyTrackingTab> {
  List<StudySessionRow> _rows = <StudySessionRow>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_reload());
  }

  Future<void> _reload() async {
    final List<StudySessionRow> next =
        await StudySessionRepository.instance.queryAllDescending();
    if (!mounted) {
      return;
    }
    setState(() {
      _rows = next;
      _loading = false;
    });
  }

  String _formatClock(DateTime t) {
    final String h = t.hour.toString().padLeft(2, '0');
    final String m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static const List<String> _enMonthShort = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(DateTime t, String languageCode) {
    final int d = t.day;
    final int m = t.month;
    final int y = t.year;
    if (languageCode == 'vi') {
      final String dd = d.toString().padLeft(2, '0');
      final String mm = m.toString().padLeft(2, '0');
      return '$dd/$mm/$y';
    }
    return '${_enMonthShort[m - 1]} $d, $y';
  }

  bool _sameCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatSessionRange(BuildContext context, StudySessionRow row) {
    final String lang = Localizations.localeOf(context).languageCode;
    final String startClock = _formatClock(row.startedAt);
    final String endClock = _formatClock(row.endedAt);
    if (_sameCalendarDay(row.startedAt, row.endedAt)) {
      final String date = _formatDate(row.startedAt, lang);
      return '$date · $startClock — $endClock';
    }
    final String ds = _formatDate(row.startedAt, lang);
    final String de = _formatDate(row.endedAt, lang);
    return '$ds $startClock — $de $endClock';
  }

  Future<void> _confirmDelete(StudySessionRow row) async {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(l.studyTrackingDeleteTitle),
        content: Text(l.studyTrackingDeleteBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.studyTrackingCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.studyTrackingConfirmDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) {
      return;
    }
    await StudySessionRepository.instance.deleteById(row.id);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l.studyTrackingEmpty,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _rows.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (BuildContext context, int index) {
          final StudySessionRow row = _rows[index];
          final StudySubjectVisual visual = studySubjectVisual(row.subjectKey);
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
            ),
            child: ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                backgroundColor: visual.barBackgroundFor(context),
                child: Icon(visual.icon, color: visual.iconColor),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext ctx) =>
                        StudySessionDetailScreen(session: row),
                  ),
                );
              },
              title: Text(
                studySubjectLabel(l, row.subjectKey),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                '${l.studyTrackingTimeLabel}: ${_formatSessionRange(context, row)}\n'
                '${l.studyTrackingStatsLine(row.totalQuestions, row.correctCount, row.wrongCount)}',
              ),
              trailing: IconButton(
                tooltip: l.studyTrackingDeleteTooltip,
                onPressed: () => unawaited(_confirmDelete(row)),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ),
          );
        },
      ),
    );
  }
}
