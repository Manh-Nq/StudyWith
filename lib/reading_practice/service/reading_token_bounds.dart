/// Tiện ích lấy token `\S+` trong đoạn văn theo vị trí UTF-16.
class ReadingTokenBounds {
  ReadingTokenBounds._();

  static final RegExp _tokenPattern = RegExp(r'\S+');

  /// Trả về [start, end) của token chứa [utf16Offset], hoặc `null`.
  static ({int start, int end})? tokenRangeContaining(
      String text, int utf16Offset) {
    if (utf16Offset < 0 || utf16Offset > text.length) {
      return null;
    }
    for (final RegExpMatch match in _tokenPattern.allMatches(text)) {
      if (utf16Offset >= match.start && utf16Offset < match.end) {
        return (start: match.start, end: match.end);
      }
    }
    return null;
  }

  static String tokenTextAt(String text, int utf16Offset) {
    final ({int start, int end})? r = tokenRangeContaining(text, utf16Offset);
    if (r == null) {
      return '';
    }
    return text.substring(r.start, r.end);
  }
}
