/// File SQLite từ [minhqnd/dictionary Releases](https://github.com/minhqnd/dictionary/releases).
/// Khai báo trong `pubspec.yaml` → `assets/dictionary.db`.
///
/// Schema chính (đọc read-only, không migrate):
/// - **words**: `id`, `word`, `lang_code` (unique `word`+`lang_code`)
/// - **word_definitions**: nối `word_id` ↔ `definition_id`, `example`
/// - **definitions**: `definition`, `definition_lang`, `pos`, `sub_pos`
/// - **sources**: tên nguồn
/// - **pronunciations**, **translations**, **word_relations**
///
/// Query mẫu upstream: [dictionary.ts](https://github.com/minhqnd/dictionary/blob/main/lib/dictionary.ts).
abstract final class DictionaryConstants {
  static const String bundledAssetPath = 'assets/dictionary.db';

  /// Tăng khi thay file `assets/dictionary.db` để app copy lại bản mới.
  static const String bundledAssetVersion = 'minhqnd-dictionary-v2.0.0';

  /// File làm việc trong thư mục databases của app (không ghi đè `study_sessions.db`).
  static const String installedFileName = 'minhqnd_dictionary.db';

  static const String prefsInstalledVersionKey =
      'language_study_dictionary_installed_version';

  /// Bảng trong `dictionary.db` (để query EN–VN ở bước sau).
  static const String tableWords = 'words';
  static const String tableDefinitions = 'definitions';
  static const String tableWordDefinitions = 'word_definitions';
  static const String tableTranslations = 'translations';
  static const String tablePronunciations = 'pronunciations';
  static const String tableWordRelations = 'word_relations';
  static const String tableSources = 'sources';
}
