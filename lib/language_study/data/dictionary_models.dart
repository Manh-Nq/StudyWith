/// Một nghĩa (định nghĩa) gắn với từ — EN→VN: `definition` là tiếng Việt.
class DictionarySense {
  const DictionarySense({
    required this.definition,
    this.example,
    this.pos,
    this.subPos,
    this.sourceName,
  });
  final String definition;
  final String? example;
  final String? pos;
  final String? subPos;
  final String? sourceName;
}

class DictionaryPronunciation {
  const DictionaryPronunciation({required this.ipa, this.region});
  final String ipa;
  final String? region;
}

/// Kết quả tra cứu một từ (headword + nghĩa đích + IPA).
class DictionaryLookupResult {
  const DictionaryLookupResult({
    required this.wordId,
    required this.word,
    required this.senses,
    required this.pronunciations,
  });
  final int wordId;
  final String word;
  final List<DictionarySense> senses;
  final List<DictionaryPronunciation> pronunciations;
}

/// Mục trong danh sách (học / kiểm tra) — từ, IPA, nghĩa xem trước.
class DictionaryListItem {
  const DictionaryListItem({
    required this.wordId,
    required this.headword,
    this.ipaPreview,
    this.meaningPreview,
  });
  final int wordId;
  final String headword;
  final String? ipaPreview;
  final String? meaningPreview;
}

/// 20 từ cùng một chủ đề (DB: nhóm theo loại từ / POS).
class DictionaryTopicBatch {
  const DictionaryTopicBatch({
    required this.topicCode,
    required this.items,
  });
  final String topicCode;
  final List<DictionaryListItem> items;
}

/// @deprecated Dùng [DictionaryLookupResult].
typedef EnVnLookupResult = DictionaryLookupResult;
