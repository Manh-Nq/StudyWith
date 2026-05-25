import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/language_pair_id.dart';

/// Từ đã xuất hiện khi học (theo cặp ngôn ngữ) — dùng cho màn kiểm tra.
class LanguageStudyLearnedWordsStore {
  LanguageStudyLearnedWordsStore._();
  static final LanguageStudyLearnedWordsStore instance =
      LanguageStudyLearnedWordsStore._();

  static String _prefsKey(LanguagePairId pair) =>
      'language_study_learned_word_ids_${pair.name}';

  Future<Set<int>> getLearnedWordIds(LanguagePairId pair) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_prefsKey(pair));
    if (raw == null || raw.isEmpty) {
      return <int>{};
    }
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) {
        return <int>{};
      }
      return decoded
          .map((Object? e) => e is int ? e : int.tryParse('$e'))
          .whereType<int>()
          .toSet();
    } catch (_) {
      return <int>{};
    }
  }

  Future<int> learnedCount(LanguagePairId pair) async {
    final Set<int> ids = await getLearnedWordIds(pair);
    return ids.length;
  }

  Future<void> addLearnedWordIds(
    LanguagePairId pair,
    Iterable<int> wordIds,
  ) async {
    final Set<int> merged = await getLearnedWordIds(pair);
    merged.addAll(wordIds);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey(pair),
      jsonEncode(merged.toList()..sort()),
    );
  }
}
