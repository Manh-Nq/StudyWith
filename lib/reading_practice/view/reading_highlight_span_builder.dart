import 'package:flutter/material.dart';

class ReadingHighlightSpanBuilder {
  ReadingHighlightSpanBuilder._();

  static List<TextSpan> buildLyricSpans({
    required String appliedText,
    required int highlightStart,
    required int highlightEnd,
    required TextStyle baseStyle,
    required Color onSurface,
  }) {
    if (appliedText.isEmpty) {
      return <TextSpan>[
        TextSpan(
          text: 'Nhấn “Áp dụng” sau khi dán hoặc gõ văn bản.',
          style: baseStyle.copyWith(
              color: baseStyle.color?.withValues(alpha: 0.55)),
        ),
      ];
    }
    final List<TextSpan> spans = <TextSpan>[];
    int offset = 0;
    for (final String g in appliedText.characters) {
      final int len = g.length;
      final bool on = highlightStart >= 0 &&
          offset >= highlightStart &&
          offset + len <= highlightEnd;
      spans.add(
        TextSpan(
          text: g,
          style: baseStyle.copyWith(
            color: on ? onSurface : onSurface.withValues(alpha: 0.62),
            fontWeight: on ? FontWeight.w900 : FontWeight.w400,
            letterSpacing: on ? 0.2 : 0,
          ),
        ),
      );
      offset += len;
    }
    return spans;
  }
}
