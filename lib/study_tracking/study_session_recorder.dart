import 'study_session_repository.dart';
import 'study_subject_keys.dart';

/// Tracks one active subject at a time; persists a row when leaving or switching.
class StudySessionRecorder {
  StudySessionRecorder._();
  static final StudySessionRecorder instance = StudySessionRecorder._();
  String? _activeSubjectKey;
  DateTime? _startedAt;
  int _total = 0;
  int _correct = 0;
  int _wrong = 0;
  final List<String> _pendingGradedSnapshots = <String>[];

  Future<void> enterSubject(String subjectKey) async {
    if (_activeSubjectKey == subjectKey) {
      return;
    }
    if (_activeSubjectKey != null) {
      await persistCurrentSession();
    }
    _activeSubjectKey = subjectKey;
    _startedAt = DateTime.now();
    _total = 0;
    _correct = 0;
    _wrong = 0;
    _pendingGradedSnapshots.clear();
  }

  Future<void> leaveSubject(String subjectKey) async {
    if (_activeSubjectKey != subjectKey) {
      return;
    }
    await persistCurrentSession();
  }

  Future<void> persistCurrentSession() async {
    final String? key = _activeSubjectKey;
    final DateTime? start = _startedAt;
    _activeSubjectKey = null;
    _startedAt = null;
    final int total = _total;
    final int correct = _correct;
    final int wrong = _wrong;
    final List<String> snapshots = List<String>.from(_pendingGradedSnapshots);
    _total = 0;
    _correct = 0;
    _wrong = 0;
    _pendingGradedSnapshots.clear();
    if (key == null || start == null) {
      return;
    }
    final DateTime ended = DateTime.now();
    await StudySessionRepository.instance.insert(
      subjectKey: key,
      startedAt: start,
      endedAt: ended,
      totalQuestions: total,
      correctCount: correct,
      wrongCount: wrong,
      gradedSnapshotJsons: _storesGradedSnapshots(key) && snapshots.isNotEmpty
          ? snapshots
          : null,
    );
  }

  static bool _storesGradedSnapshots(String subjectKey) {
    return subjectKey == StudySubjectKeys.math ||
        subjectKey == StudySubjectKeys.languageStudyEnVi;
  }

  void recordGradedAnswer({
    required bool isCorrect,
    String? gradedSnapshotJson,
    String? mathGradedSnapshotJson,
  }) {
    if (_activeSubjectKey == null) {
      return;
    }
    _total += 1;
    if (isCorrect) {
      _correct += 1;
    } else {
      _wrong += 1;
    }
    final String? snap = gradedSnapshotJson ?? mathGradedSnapshotJson;
    if (_storesGradedSnapshots(_activeSubjectKey!) && snap != null) {
      _pendingGradedSnapshots.add(snap);
    }
  }

  /// One full read-through of all units (play completed without stop).
  void recordReadingPassCompleted() {
    if (_activeSubjectKey == null) {
      return;
    }
    _total += 1;
    _correct += 1;
  }

  void recordAlphabetListenCompleted() {
    if (_activeSubjectKey == null) {
      return;
    }
    _total += 1;
    _correct += 1;
  }

  void recordAlphabetSpellCompleted() {
    if (_activeSubjectKey == null) {
      return;
    }
    _total += 1;
    _correct += 1;
  }
}
