import 'package:characters/characters.dart';

import '../model/reading_unit.dart';
import 'vietnamese_educational_spelling.dart';

class ReadingSegmentBuilder {
  ReadingSegmentBuilder._();

  static final RegExp _tokenPattern = RegExp(r'\S+');

  static bool containsLetter(String text) {
    return RegExp(r'\p{L}', unicode: true).hasMatch(text);
  }

  /// Luôn đánh vần kiểu SGK (âm đầu → vần → ghép → thanh → tiếng).
  static List<ReadingUnit> build(String raw) {
    final List<ReadingUnit> units = <ReadingUnit>[];
    if (raw.isEmpty) {
      return units;
    }
    for (final RegExpMatch match in _tokenPattern.allMatches(raw)) {
      final String token = match.group(0)!;
      final int start = match.start;
      final int end = match.end;
      if (!containsLetter(token)) {
        units.add(ReadingUnit(start: start, end: end, speakText: token));
        continue;
      }
      final List<String>? steps =
          VietnameseEducationalSpelling.speakStepsForToken(token);
      if (steps != null) {
        for (int si = 0; si < steps.length; si++) {
          final bool isFinalWordStep = si == steps.length - 1;
          final String step = steps[si];
          final String speakText = isFinalWordStep
              ? step
              : VietnameseEducationalSpelling.ttsSpeakForIntermediateLetterStep(
                  step);
          units.add(ReadingUnit(start: start, end: end, speakText: speakText));
        }
        continue;
      }
      _appendGraphemeLettersThenWhole(units, token, start, end);
    }
    return units;
  }

  static void _appendGraphemeLettersThenWhole(
    List<ReadingUnit> units,
    String token,
    int start,
    int end,
  ) {
    int offset = start;
    for (final String g in token.characters) {
      final int len = g.length;
      final String speakLetter =
          VietnameseEducationalSpelling.ttsSpeakForIntermediateLetterStep(g);
      units.add(
        ReadingUnit(start: offset, end: offset + len, speakText: speakLetter),
      );
      offset += len;
    }
    units.add(ReadingUnit(start: start, end: end, speakText: token));
  }

  static int indexOfUnitAtOrBefore(List<ReadingUnit> units, int textOffset) {
    if (units.isEmpty) {
      return 0;
    }
    for (int i = units.length - 1; i >= 0; i--) {
      if (units[i].start <= textOffset) {
        return i;
      }
    }
    return 0;
  }
}
