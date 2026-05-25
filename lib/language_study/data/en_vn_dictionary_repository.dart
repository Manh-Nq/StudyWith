import 'dart:math';

import 'package:sqflite/sqflite.dart';

import 'dictionary_constants.dart';
import 'dictionary_database_manager.dart';
import 'dictionary_models.dart';
import 'language_study_dictionary_repository.dart';

/// Tra cứu & gợi ý **tiếng Anh → định nghĩa tiếng Việt** trên [DictionaryConstants] DB.
class EnVnDictionaryRepository implements LanguageStudyDictionaryRepository {
  EnVnDictionaryRepository({DictionaryDatabaseManager? manager})
      : _manager = manager ?? DictionaryDatabaseManager.instance;

  final DictionaryDatabaseManager _manager;

  static const String _langEn = 'en';
  static const String _langDefVi = 'vi';

  /// Chủ đề học: nhóm theo loại từ (DB không có trường topic riêng).
  static const List<String> _learnTopicPosCodes = <String>['N', 'V', 'A', 'D'];

  static String normalizeEnglishInput(String raw) {
    return raw.trim().toLowerCase();
  }

  static String escapeLikePattern(String prefix) {
    return prefix
        .replaceAll('/', '//')
        .replaceAll('%', '/%')
        .replaceAll('_', '/_');
  }

  @override
  Future<void> warmUp() async {
    await lookup('hello');
  }

  Future<List<String>> suggestEnglishPrefix(
    String rawPrefix, {
    int limit = 12,
  }) async {
    return suggestPrefix(rawPrefix, limit: limit);
  }

  @override
  Future<List<String>> suggestPrefix(
    String rawPrefix, {
    int limit = 12,
  }) async {
    final String p = normalizeEnglishInput(rawPrefix);
    if (p.isEmpty || limit <= 0) {
      return <String>[];
    }
    final String like = '${escapeLikePattern(p)}%';
    final Database db = await _manager.openReadOnly();
    final List<Map<String, Object?>> rows = await db.rawQuery(
      '''
SELECT DISTINCT ${DictionaryConstants.tableWords}.word AS w
FROM ${DictionaryConstants.tableWords}
WHERE ${DictionaryConstants.tableWords}.word LIKE ? ESCAPE '/'
  AND ${DictionaryConstants.tableWords}.lang_code = ?
ORDER BY LENGTH(${DictionaryConstants.tableWords}.word), ${DictionaryConstants.tableWords}.word
LIMIT ?
''',
      <Object?>[like, _langEn, limit],
    );
    return rows
        .map((Map<String, Object?> m) => m['w'] as String?)
        .whereType<String>()
        .toList();
  }

  Future<DictionaryLookupResult?> lookupEnglishToVietnamese(String rawWord) =>
      lookup(rawWord);

  @override
  Future<DictionaryLookupResult?> lookup(String rawWord) async {
    final String w = normalizeEnglishInput(rawWord);
    if (w.isEmpty) {
      return null;
    }
    final Database db = await _manager.openReadOnly();
    final List<Map<String, Object?>> wordRows = await db.query(
      DictionaryConstants.tableWords,
      columns: <String>['id', 'word'],
      where: 'word = ? AND lang_code = ?',
      whereArgs: <Object?>[w, _langEn],
      limit: 1,
    );
    if (wordRows.isEmpty) {
      return null;
    }
    return _loadResult(
      db,
      wordRows.first['id']! as int,
      wordRows.first['word']! as String,
    );
  }

  @override
  Future<DictionaryLookupResult?> lookupByWordId(int wordId) async {
    final Database db = await _manager.openReadOnly();
    final List<Map<String, Object?>> wordRows = await db.query(
      DictionaryConstants.tableWords,
      columns: <String>['id', 'word'],
      where: 'id = ? AND lang_code = ?',
      whereArgs: <Object?>[wordId, _langEn],
      limit: 1,
    );
    if (wordRows.isEmpty) {
      return null;
    }
    return _loadResult(
      db,
      wordRows.first['id']! as int,
      wordRows.first['word']! as String,
    );
  }

  @override
  Future<List<DictionaryListItem>> randomHeadwords({int limit = 20}) async {
    final DictionaryTopicBatch batch =
        await randomHeadwordsByTopic(limit: limit);
    return batch.items;
  }

  @override
  Future<DictionaryTopicBatch> randomHeadwordsByTopic({int limit = 20}) async {
    if (limit <= 0) {
      return const DictionaryTopicBatch(topicCode: 'N', items: <DictionaryListItem>[]);
    }
    final String pos =
        _learnTopicPosCodes[Random().nextInt(_learnTopicPosCodes.length)];
    final Database db = await _manager.openReadOnly();
    final List<Map<String, Object?>> rows = await db.rawQuery(
      '''
SELECT DISTINCT w.id AS id, w.word AS word
FROM ${DictionaryConstants.tableWords} w
INNER JOIN ${DictionaryConstants.tableWordDefinitions} wd ON wd.word_id = w.id
INNER JOIN ${DictionaryConstants.tableDefinitions} d ON d.id = wd.definition_id
WHERE w.lang_code = ?
  AND d.definition_lang = ?
  AND d.pos = ?
  AND LENGTH(w.word) BETWEEN 2 AND 24
  AND w.word NOT LIKE '% %'
  AND w.word GLOB '[a-z]*'
ORDER BY RANDOM()
LIMIT ?
''',
      <Object?>[_langEn, _langDefVi, pos, limit],
    );
    final List<DictionaryListItem> items = await _rowsToListItems(db, rows);
    return DictionaryTopicBatch(topicCode: pos, items: items);
  }

  @override
  Future<List<DictionaryListItem>> listItemsByWordIds(List<int> wordIds) async {
    if (wordIds.isEmpty) {
      return <DictionaryListItem>[];
    }
    final Database db = await _manager.openReadOnly();
    final String placeholders = List<String>.filled(wordIds.length, '?').join(',');
    final List<Map<String, Object?>> rows = await db.rawQuery(
      '''
SELECT w.id AS id, w.word AS word
FROM ${DictionaryConstants.tableWords} w
WHERE w.lang_code = ? AND w.id IN ($placeholders)
''',
      <Object?>[_langEn, ...wordIds],
    );
    return _rowsToListItems(db, rows);
  }

  Future<DictionaryLookupResult> _loadResult(
    Database db,
    int wordId,
    String word,
  ) async {
    final List<Map<String, Object?>> senseRows = await db.rawQuery(
      '''
SELECT d.definition AS definition,
       wd.example AS example,
       d.pos AS pos,
       d.sub_pos AS sub_pos,
       s.name AS source_name
FROM ${DictionaryConstants.tableWordDefinitions} wd
JOIN ${DictionaryConstants.tableDefinitions} d ON wd.definition_id = d.id
LEFT JOIN ${DictionaryConstants.tableSources} s ON wd.source_id = s.id
WHERE wd.word_id = ? AND d.definition_lang = ?
ORDER BY d.id
''',
      <Object?>[wordId, _langDefVi],
    );
    final List<DictionarySense> senses = senseRows.map((Map<String, Object?> m) {
      return DictionarySense(
        definition: m['definition']! as String,
        example: m['example'] as String?,
        pos: m['pos'] as String?,
        subPos: m['sub_pos'] as String?,
        sourceName: m['source_name'] as String?,
      );
    }).toList();
    final List<DictionaryPronunciation> pronunciations =
        await _pronunciationsForWord(db, wordId);
    return DictionaryLookupResult(
      wordId: wordId,
      word: word,
      senses: senses,
      pronunciations: pronunciations,
    );
  }

  Future<List<DictionaryListItem>> _rowsToListItems(
    Database db,
    List<Map<String, Object?>> rows,
  ) async {
    if (rows.isEmpty) {
      return <DictionaryListItem>[];
    }
    final List<int> ids = rows
        .map((Map<String, Object?> m) => m['id']! as int)
        .toList();
    final Map<int, String?> ipaById = await _firstIpaByWordIds(db, ids);
    final Map<int, String?> meaningById = await _firstMeaningByWordIds(db, ids);
    return rows.map((Map<String, Object?> m) {
      final int id = m['id']! as int;
      return DictionaryListItem(
        wordId: id,
        headword: m['word']! as String,
        ipaPreview: ipaById[id],
        meaningPreview: meaningById[id],
      );
    }).toList();
  }

  Future<Map<int, String?>> _firstMeaningByWordIds(
    Database db,
    List<int> wordIds,
  ) async {
    final String placeholders = List<String>.filled(wordIds.length, '?').join(',');
    final List<Map<String, Object?>> rows = await db.rawQuery(
      '''
SELECT wd.word_id AS word_id, MIN(d.definition) AS meaning
FROM ${DictionaryConstants.tableWordDefinitions} wd
JOIN ${DictionaryConstants.tableDefinitions} d ON d.id = wd.definition_id
WHERE wd.word_id IN ($placeholders) AND d.definition_lang = ?
GROUP BY wd.word_id
''',
      <Object?>[...wordIds, _langDefVi],
    );
    final Map<int, String?> out = <int, String?>{};
    for (final Map<String, Object?> row in rows) {
      out[row['word_id']! as int] = row['meaning'] as String?;
    }
    return out;
  }

  Future<Map<int, String?>> _firstIpaByWordIds(
    Database db,
    List<int> wordIds,
  ) async {
    final String placeholders = List<String>.filled(wordIds.length, '?').join(',');
    final List<Map<String, Object?>> pronRows = await db.rawQuery(
      '''
SELECT word_id, ipa FROM ${DictionaryConstants.tablePronunciations}
WHERE word_id IN ($placeholders)
ORDER BY word_id, id
''',
      wordIds,
    );
    final Map<int, String?> out = <int, String?>{};
    for (final Map<String, Object?> row in pronRows) {
      final int wid = row['word_id']! as int;
      out.putIfAbsent(wid, () => row['ipa'] as String?);
    }
    return out;
  }

  Future<List<DictionaryPronunciation>> _pronunciationsForWord(
    Database db,
    int wordId,
  ) async {
    final List<Map<String, Object?>> pronRows = await db.query(
      DictionaryConstants.tablePronunciations,
      columns: <String>['ipa', 'region'],
      where: 'word_id = ?',
      whereArgs: <Object?>[wordId],
    );
    return pronRows.map((Map<String, Object?> m) {
      return DictionaryPronunciation(
        ipa: m['ipa']! as String,
        region: m['region'] as String?,
      );
    }).toList();
  }
}
