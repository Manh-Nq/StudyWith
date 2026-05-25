import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class StudySessionRow {
  const StudySessionRow({
    required this.id,
    required this.subjectKey,
    required this.startedAt,
    required this.endedAt,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
  });
  final int id;
  final String subjectKey;
  final DateTime startedAt;
  final DateTime endedAt;
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;

  factory StudySessionRow.fromMap(Map<String, Object?> map) {
    return StudySessionRow(
      id: map['id']! as int,
      subjectKey: map['subject_key']! as String,
      startedAt:
          DateTime.fromMillisecondsSinceEpoch(map['started_at']! as int),
      endedAt: DateTime.fromMillisecondsSinceEpoch(map['ended_at']! as int),
      totalQuestions: map['total_questions']! as int,
      correctCount: map['correct_count']! as int,
      wrongCount: map['wrong_count']! as int,
    );
  }
}

/// Một câu đã làm trong phiên (hiện dùng cho toán: JSON snapshot).
class StudySessionGradedAttemptRow {
  const StudySessionGradedAttemptRow({
    required this.id,
    required this.sessionId,
    required this.ordinal,
    required this.snapshotJson,
  });
  final int id;
  final int sessionId;
  final int ordinal;
  final String snapshotJson;

  Map<String, Object?> decodeSnapshot() {
    final Object? decoded = jsonDecode(snapshotJson);
    if (decoded is Map<String, Object?>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map(
        (Object? k, Object? v) => MapEntry(k!.toString(), v),
      );
    }
    return <String, Object?>{};
  }

  factory StudySessionGradedAttemptRow.fromMap(Map<String, Object?> map) {
    return StudySessionGradedAttemptRow(
      id: map['id']! as int,
      sessionId: map['session_id']! as int,
      ordinal: map['ordinal']! as int,
      snapshotJson: map['snapshot_json']! as String,
    );
  }
}

class StudySessionRepository {
  StudySessionRepository._();
  static final StudySessionRepository instance = StudySessionRepository._();
  Database? _db;

  Future<Database> _database() async {
    if (_db != null) {
      return _db!;
    }
    final String dir = await getDatabasesPath();
    final String path = p.join(dir, 'study_sessions.db');
    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await _createV1Tables(db);
        await _createGradedAttemptsTable(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await _createGradedAttemptsTable(db);
        }
      },
    );
    return _db!;
  }

  Future<void> _createV1Tables(Database db) async {
    await db.execute('''
CREATE TABLE study_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  subject_key TEXT NOT NULL,
  started_at INTEGER NOT NULL,
  ended_at INTEGER NOT NULL,
  total_questions INTEGER NOT NULL,
  correct_count INTEGER NOT NULL,
  wrong_count INTEGER NOT NULL
)
''');
  }

  Future<void> _createGradedAttemptsTable(Database db) async {
    await db.execute('''
CREATE TABLE IF NOT EXISTS study_session_graded_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  ordinal INTEGER NOT NULL,
  snapshot_json TEXT NOT NULL,
  FOREIGN KEY(session_id) REFERENCES study_sessions(id) ON DELETE CASCADE
)
''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_graded_session ON study_session_graded_attempts(session_id)',
    );
  }

  Future<int> insert({
    required String subjectKey,
    required DateTime startedAt,
    required DateTime endedAt,
    required int totalQuestions,
    required int correctCount,
    required int wrongCount,
    List<String>? gradedSnapshotJsons,
  }) async {
    final Database db = await _database();
    late final int sessionId;
    await db.transaction((Transaction txn) async {
      sessionId = await txn.insert(
        'study_sessions',
        <String, Object?>{
          'subject_key': subjectKey,
          'started_at': startedAt.millisecondsSinceEpoch,
          'ended_at': endedAt.millisecondsSinceEpoch,
          'total_questions': totalQuestions,
          'correct_count': correctCount,
          'wrong_count': wrongCount,
        },
      );
      final List<String> snaps = gradedSnapshotJsons ?? const <String>[];
      for (int i = 0; i < snaps.length; i++) {
        await txn.insert(
          'study_session_graded_attempts',
          <String, Object?>{
            'session_id': sessionId,
            'ordinal': i,
            'snapshot_json': snaps[i],
          },
        );
      }
    });
    return sessionId;
  }

  Future<List<StudySessionRow>> queryAllDescending() async {
    final Database db = await _database();
    final List<Map<String, Object?>> maps = await db.query(
      'study_sessions',
      orderBy: 'ended_at DESC',
    );
    return maps.map(StudySessionRow.fromMap).toList();
  }

  Future<List<StudySessionGradedAttemptRow>> queryGradedAttempts(
    int sessionId,
  ) async {
    final Database db = await _database();
    final List<Map<String, Object?>> maps = await db.query(
      'study_session_graded_attempts',
      where: 'session_id = ?',
      whereArgs: <Object?>[sessionId],
      orderBy: 'ordinal ASC',
    );
    return maps.map(StudySessionGradedAttemptRow.fromMap).toList();
  }

  Future<void> deleteById(int id) async {
    final Database db = await _database();
    await db.delete(
      'study_session_graded_attempts',
      where: 'session_id = ?',
      whereArgs: <Object?>[id],
    );
    await db.delete(
      'study_sessions',
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }
}
