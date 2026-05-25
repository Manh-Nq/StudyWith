import 'dictionary_models.dart';

/// Tra cứu offline cho một cặp ngôn ngữ (EN→VN, VN→EN, …).
abstract class LanguageStudyDictionaryRepository {
  Future<void> warmUp();

  Future<List<String>> suggestPrefix(String rawPrefix, {int limit = 12});

  Future<DictionaryLookupResult?> lookup(String rawWord);

  Future<DictionaryLookupResult?> lookupByWordId(int wordId);

  /// [limit] từ ngẫu nhiên (có IPA + nghĩa xem trước).
  Future<List<DictionaryListItem>> randomHeadwords({int limit = 20});

  /// [limit] từ ngẫu nhiên trong **một chủ đề** (POS: N/V/A/D), chủ đề đổi mỗi lần gọi.
  Future<DictionaryTopicBatch> randomHeadwordsByTopic({int limit = 20});

  /// Nạp lại headword + IPA + nghĩa theo id (màn kiểm tra từ đã học).
  Future<List<DictionaryListItem>> listItemsByWordIds(List<int> wordIds);
}
