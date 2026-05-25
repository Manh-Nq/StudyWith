import 'package:characters/characters.dart';

/// Đánh vần theo **âm** (chương trình Công nghệ Giáo dục / SGK):
/// [âm đầu đọc tên] → [vần / cụm vần không thanh] → [ghép không thanh]
/// → ([tên thanh] nếu không phải thanh ngang) → [đọc lại cả tiếng].
///
/// Tiếng **không có phụ âm đầu** nhưng có **âm cuối** (`em`, `anh`, `ong`…)
/// được tách **âm chính + âm cuối** (vd. `em`: e — mờ — em), không coi `n` trong `anh` là âm đầu.
///
/// Ví dụ `nhiều`: nhờ — iêu — nhiêu — huyền — nhiều. `Theo`: thờ — eo — theo — theo (không đọc "ngang").
class VietnameseEducationalSpelling {
  VietnameseEducationalSpelling._();

  /// Âm cuối (đuôi) — khớp dài trước: `nh`, `ng`, `ch` trước `n`, `m`…
  static const List<String> _codasLongestFirst = <String>[
    'ng',
    'nh',
    'ch',
    'n',
    'm',
    'p',
    't',
    'c',
  ];

  /// Vần không âm đầu cần tách **nhiều bước** theo bảng CNGD (Tripi / sách Công nghệ).
  /// Giá trị: các cụm **không dấu thanh** (đồng bộ với [stripToneMarks] của cả tiếng).
  static const Map<String, List<String>> _zeroOnsetPedagogyChunks =
      <String, List<String>>{
    'oai': <String>['o', 'ai'],
    'oay': <String>['o', 'ay'],
    'oan': <String>['o', 'an'],
    'oăn': <String>['o', 'ăn'],
    'oang': <String>['o', 'ang'],
    'oăng': <String>['o', 'ăng'],
    'oanh': <String>['o', 'anh'],
    'oach': <String>['o', 'ach'],
    'oat': <String>['o', 'at'],
    'oăt': <String>['o', 'ăt'],
    'oi': <String>['o', 'i'],
    'uân': <String>['u', 'ân'],
    'uât': <String>['u', 'ât'],
    'uyên': <String>['u', 'yên'],
    'uych': <String>['u', 'ych'],
    'uynh': <String>['u', 'ynh'],
    'uyêt': <String>['u', 'yêt'],
    'uya': <String>['u', 'ya'],
    'uyt': <String>['u', 'yt'],
    'uôm': <String>['ua', 'm'],
    'uôt': <String>['ua', 't'],
    'uôc': <String>['ua', 'c'],
    'uông': <String>['ua', 'ng'],
    'uôi': <String>['ua', 'i'],
    'uôn': <String>['ua', 'n'],
    'iêu': <String>['ia', 'u'],
    'yêu': <String>['ia', 'u'],
    'iên': <String>['ia', 'n'],
    'yên': <String>['ia', 'n'],
    'iêt': <String>['ia', 't'],
    'iêc': <String>['ia', 'c'],
    'iêp': <String>['ia', 'p'],
    'iêng': <String>['ia', 'ng'],
    'yêm': <String>['ia', 'm'],
    'ươi': <String>['ưa', 'i'],
    'ươn': <String>['ưa', 'n'],
    'ươm': <String>['ưa', 'm'],
    'ương': <String>['ưa', 'ng'],
    'ươc': <String>['ưa', 'c'],
    'ươp': <String>['ưa', 'p'],
    'ươu': <String>['ưa', 'u'],
    'oa': <String>['o', 'a'],
    'ua': <String>['u', 'a'],
    'oe': <String>['o', 'e'],
    'ôi': <String>['ô', 'i'],
    'ơi': <String>['ơ', 'i'],
    'ui': <String>['u', 'i'],
    'ưi': <String>['ư', 'i'],
    'iu': <String>['i', 'u'],
    'êu': <String>['ê', 'u'],
    'ưu': <String>['ư', 'u'],
    'eo': <String>['e', 'o'],
    'ao': <String>['a', 'o'],
    'au': <String>['a', 'u'],
    'âu': <String>['â', 'u'],
    'ây': <String>['â', 'y'],
    'uây': <String>['u', 'ây'],
    'uôy': <String>['ua', 'y'],
    'yê': <String>['ia', 'e'],
    'iê': <String>['ia', 'e'],
    'oăm': <String>['o', 'ăm'],
    'oăc': <String>['o', 'ăc'],
    'oăp': <String>['o', 'ăp'],
  };

  static const Set<String> _bogusRhymeTails = <String>{
    'ah',
    'eh',
    'ih',
    'oh',
    'uh',
    'yh',
    'eo',
    'ew',
  };

  static final List<String> _onsetsLongestFirst = <String>[
    'ngh',
    'gh',
    'ng',
    'ch',
    'kh',
    'th',
    'tr',
    'ph',
    'nh',
    'gi',
    'qu',
    'đ',
    'b',
    'c',
    'd',
    'g',
    'h',
    'k',
    'l',
    'm',
    'n',
    'p',
    'r',
    's',
    't',
    'v',
    'x',
  ];

  /// Tên đọc âm đầu khi đánh vần — **một âm tiết** kiểu …ờ (mờ, cờ, …), không đọc kiểu “em mờ”, “ét sì”.
  static const Map<String, String> _onsetReadName = <String, String>{
    'b': 'bờ',
    'c': 'cờ',
    'ch': 'chờ',
    'd': 'dờ',
    'đ': 'đờ',
    'g': 'gờ',
    'gh': 'gờ hát',
    'gi': 'giê',
    'h': 'hờ',
    'k': 'ca',
    'kh': 'khờ',
    'l': 'lờ',
    'm': 'mờ',
    'n': 'nờ',
    'ng': 'ngờ',
    'ngh': 'nờ ghép',
    'nh': 'nhờ',
    'p': 'pờ',
    'ph': 'phờ',
    'q': 'cu',
    'qu': 'cờ',
    'r': 'rờ',
    's': 'sờ',
    't': 'tờ',
    'th': 'thờ',
    'tr': 'trờ',
    'v': 'vờ',
    'x': 'xờ',
  };

  /// Ký tự không nhìn thấy để giọng vi-VN ít bật kiểu đọc tên chữ ("i ngắn", "y ngắn").
  static const String _ttsLetterIsolation = '\u200b';

  /// Đánh vần từng chữ / các bước giữa (không phải đọc lại cả tiếng cuối).
  /// **i** và **y** đọc gọn là /i/ và /y/, không kèm "ngắn–dài".
  static String ttsSpeakForIntermediateLetterStep(String step) {
    final String trimmed = step.trim();
    if (trimmed.isEmpty) {
      return step;
    }
    if (trimmed.characters.length != 1) {
      return step;
    }
    final String c = trimmed.characters.first.toLowerCase();
    const Set<String> iFamily = <String>{
      'i',
      'ì',
      'ỉ',
      'ĩ',
      'í',
      'ị',
    };
    const Set<String> yFamily = <String>{
      'y',
      'ý',
      'ỳ',
      'ỷ',
      'ỹ',
      'ỵ',
    };
    if (yFamily.contains(c)) {
      return '$_ttsLetterIsolation'
          'y'
          '$_ttsLetterIsolation';
    }
    if (iFamily.contains(c)) {
      return '$_ttsLetterIsolation'
          'i'
          '$_ttsLetterIsolation';
    }
    return step;
  }

  /// Trả về các bước đọc; **không** chèn bước tên thanh nếu là thanh ngang.
  /// `null` nếu không áp dụng được (ký tự đặc biệt, không có vần, v.v.).
  static List<String>? speakStepsForToken(String token) {
    final String trimmed = token.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final String lettersOnly = _lettersOnlyLower(trimmed);
    if (lettersOnly.isEmpty || lettersOnly.length > 18) {
      return null;
    }
    final String base = stripToneMarks(lettersOnly);
    if (base.isEmpty || !_looksLikeTonelessVietnameseLetters(base)) {
      return null;
    }
    final String onset = _takeOnsetValidated(base);
    final String rhymeNoTone = base.substring(onset.length);
    if (rhymeNoTone.isEmpty) {
      return null;
    }
    final String toneName = detectToneName(trimmed);
    if (onset.isEmpty) {
      return _speakStepsZeroOnset(rhymeNoTone, trimmed, toneName);
    }
    final String? onsetSpeak = _onsetReadName[onset];
    if (onsetSpeak == null) {
      return null;
    }
    final String rhymeForSpellingStep =
        onset == 'qu' ? _pedagogyRhymeAfterQu(rhymeNoTone) : rhymeNoTone;
    final String blendNoTone = '$onset$rhymeNoTone';
    final List<String> steps = <String>[
      onsetSpeak,
      rhymeForSpellingStep,
      blendNoTone,
    ];
    if (toneName != 'ngang') {
      steps.add(toneName);
    }
    steps.add(trimmed);
    return steps;
  }

  static List<String> _speakStepsZeroOnset(
    String rhymeNoTone,
    String trimmed,
    String toneName,
  ) {
    final List<String> spellChunks = <String>[];
    final List<String>? pedagogy = _zeroOnsetPedagogyChunks[rhymeNoTone];
    if (pedagogy != null) {
      spellChunks.addAll(pedagogy);
    } else {
      final ({String nucleus, String? coda}) split =
          _splitNucleusCoda(rhymeNoTone);
      if (split.coda != null && split.nucleus.isNotEmpty) {
        final String? codaSpeak = _codaReadName(split.coda!);
        if (codaSpeak != null) {
          spellChunks.add(split.nucleus);
          spellChunks.add(codaSpeak);
        } else {
          spellChunks.add(rhymeNoTone);
        }
      } else {
        spellChunks.add(rhymeNoTone);
      }
    }
    final List<String> steps = <String>[];
    if (spellChunks.length == 1 && spellChunks[0] == rhymeNoTone) {
      steps.add(rhymeNoTone);
    } else {
      steps.addAll(spellChunks);
      steps.add(rhymeNoTone);
    }
    if (toneName != 'ngang') {
      steps.add(toneName);
    }
    steps.add(trimmed);
    return steps;
  }

  static final RegExp _vowelLetterToneless =
      RegExp('[aăâeêioôơuưy]', caseSensitive: false);

  static bool _hasVietnameseVowelLetter(String s) {
    return _vowelLetterToneless.hasMatch(s);
  }

  static bool _isValidRhymeTail(String tail) {
    if (tail.isEmpty || !_hasVietnameseVowelLetter(tail)) {
      return false;
    }
    if (_bogusRhymeTails.contains(tail)) {
      return false;
    }
    if (tail.length == 2) {
      final List<String> g = tail.characters.toList();
      if (g.length == 2 &&
          _vowelLetterToneless.hasMatch(g[0]) &&
          !_vowelLetterToneless.hasMatch(g[1])) {
        const Set<String> okSecond = <String>{
          'n',
          'm',
          'p',
          't',
          'c',
        };
        if (!okSecond.contains(g[1].toLowerCase())) {
          return false;
        }
      }
    }
    return true;
  }

  static String _takeOnsetValidated(String baseLower) {
    if (_zeroOnsetPedagogyChunks.containsKey(baseLower)) {
      return '';
    }
    for (final String o in _onsetsLongestFirst) {
      if (o == 'u' && baseLower.startsWith('uy')) {
        continue;
      }
      if (baseLower.startsWith(o)) {
        final String tail = baseLower.substring(o.length);
        if (_isValidRhymeTail(tail)) {
          return o;
        }
      }
    }
    if (_isValidRhymeTail(baseLower)) {
      return '';
    }
    return _takeOnsetGreedy(baseLower);
  }

  static String _takeOnsetGreedy(String baseLower) {
    for (final String o in _onsetsLongestFirst) {
      if (baseLower.startsWith(o)) {
        return o;
      }
    }
    return '';
  }

  static ({String nucleus, String? coda}) _splitNucleusCoda(String rime) {
    for (final String c in _codasLongestFirst) {
      if (rime.endsWith(c)) {
        final String nucleus = rime.substring(0, rime.length - c.length);
        if (nucleus.isNotEmpty && _hasVietnameseVowelLetter(nucleus)) {
          return (nucleus: nucleus, coda: c);
        }
      }
    }
    return (nucleus: rime, coda: null);
  }

  static String _pedagogyRhymeAfterQu(String rhymeToneless) {
    if (rhymeToneless.isEmpty) {
      return rhymeToneless;
    }
    if (rhymeToneless == 'a') {
      return 'oa';
    }
    if (rhymeToneless.startsWith('ă')) {
      return 'o$rhymeToneless';
    }
    if (rhymeToneless.startsWith('a')) {
      return 'o$rhymeToneless';
    }
    if (rhymeToneless.startsWith('â')) {
      return 'u$rhymeToneless';
    }
    if (rhymeToneless.startsWith('e') || rhymeToneless.startsWith('ê')) {
      return 'u$rhymeToneless';
    }
    if (rhymeToneless.startsWith('ô')) {
      return 'u$rhymeToneless';
    }
    if (rhymeToneless.startsWith('ơ')) {
      return 'u$rhymeToneless';
    }
    if (rhymeToneless.startsWith('i')) {
      return 'u$rhymeToneless';
    }
    if (rhymeToneless.startsWith('y')) {
      return 'u$rhymeToneless';
    }
    return rhymeToneless;
  }

  static String? _codaReadName(String coda) {
    switch (coda) {
      case 'ng':
        return 'ngờ';
      case 'nh':
        return 'nhờ';
      case 'ch':
        return 'chờ';
      case 'n':
        return 'nờ';
      case 'm':
        return 'mờ';
      case 'p':
        return 'pờ';
      case 't':
        return 'tờ';
      case 'c':
        return 'cờ';
      default:
        return null;
    }
  }

  /// Chỉ chứa chữ cái tiếng Việt đã bỏ **thanh điệu** (ă â đ ê ô ơ ư y ...).
  static bool _looksLikeTonelessVietnameseLetters(String strippedLower) {
    return RegExp(r'^[a-zăâđêôơưy]+$').hasMatch(strippedLower);
  }

  static String _lettersOnlyLower(String token) {
    final StringBuffer buf = StringBuffer();
    for (final String g in token.characters) {
      final String lower = g.toLowerCase();
      if (RegExp(r'^[\p{L}]$', unicode: true).hasMatch(lower)) {
        buf.write(lower);
      }
    }
    return buf.toString();
  }

  /// Bỏ dấu thanh (giữ nguyên dấu chữ: đ, ă, â, ê, ô, ơ, ư).
  static String stripToneMarks(String syllableLower) {
    final StringBuffer out = StringBuffer();
    for (final String ch in syllableLower.characters) {
      out.write(_stripToneFromChar(ch));
    }
    return out.toString();
  }

  static String _stripToneFromChar(String ch) {
    const Map<String, String> m = <String, String>{
      'à': 'a',
      'ả': 'a',
      'ã': 'a',
      'á': 'a',
      'ạ': 'a',
      'ằ': 'ă',
      'ẳ': 'ă',
      'ẵ': 'ă',
      'ắ': 'ă',
      'ặ': 'ă',
      'ầ': 'â',
      'ẩ': 'â',
      'ẫ': 'â',
      'ấ': 'â',
      'ậ': 'â',
      'è': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'é': 'e',
      'ẹ': 'e',
      'ề': 'ê',
      'ể': 'ê',
      'ễ': 'ê',
      'ế': 'ê',
      'ệ': 'ê',
      'ì': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'í': 'i',
      'ị': 'i',
      'ò': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ó': 'o',
      'ọ': 'o',
      'ồ': 'ô',
      'ổ': 'ô',
      'ỗ': 'ô',
      'ố': 'ô',
      'ộ': 'ô',
      'ờ': 'ơ',
      'ở': 'ơ',
      'ỡ': 'ơ',
      'ớ': 'ơ',
      'ợ': 'ơ',
      'ù': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ú': 'u',
      'ụ': 'u',
      'ừ': 'ư',
      'ử': 'ư',
      'ữ': 'ư',
      'ứ': 'ư',
      'ự': 'ư',
      'ỳ': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'ý': 'y',
      'ỵ': 'y',
    };
    return m[ch] ?? ch;
  }

  /// Tên thanh theo chữ có dấu trong tiếng (ưu tiên ký tự đầu có thanh).
  static String detectToneName(String syllable) {
    const Set<String> toneHuyen = <String>{
      'à',
      'ằ',
      'ầ',
      'è',
      'ề',
      'ì',
      'ò',
      'ồ',
      'ờ',
      'ù',
      'ừ',
      'ỳ',
    };
    const Set<String> toneHoi = <String>{
      'ả',
      'ẳ',
      'ẩ',
      'ẻ',
      'ể',
      'ỉ',
      'ỏ',
      'ổ',
      'ở',
      'ủ',
      'ử',
      'ỷ',
    };
    const Set<String> toneNga = <String>{
      'ã',
      'ẵ',
      'ẫ',
      'ẽ',
      'ễ',
      'ĩ',
      'õ',
      'ỗ',
      'ỡ',
      'ũ',
      'ữ',
      'ỹ',
    };
    const Set<String> toneSac = <String>{
      'á',
      'ắ',
      'ấ',
      'é',
      'ế',
      'í',
      'ó',
      'ố',
      'ớ',
      'ú',
      'ứ',
      'ý',
    };
    const Set<String> toneNang = <String>{
      'ạ',
      'ặ',
      'ậ',
      'ẹ',
      'ệ',
      'ị',
      'ọ',
      'ộ',
      'ợ',
      'ụ',
      'ự',
      'ỵ',
    };
    for (final String g in syllable.characters) {
      final String c = g.toLowerCase();
      if (toneHuyen.contains(c)) {
        return 'huyền';
      }
      if (toneHoi.contains(c)) {
        return 'hỏi';
      }
      if (toneNga.contains(c)) {
        return 'ngã';
      }
      if (toneSac.contains(c)) {
        return 'sắc';
      }
      if (toneNang.contains(c)) {
        return 'nặng';
      }
    }
    return 'ngang';
  }

  /// Hiển thị **ký hiệu dấu** gọn, không kèm vòng tròn nền.
  /// Dùng ký hiệu kiểu gõ Telex/VNI để trẻ dễ nhìn: ` / ? ~ .
  static String toneMarkDisplay(String toneName) {
    switch (toneName) {
      case 'ngang':
        return '';
      case 'huyền':
        return '`';
      case 'hỏi':
        return '?';
      case 'ngã':
        return '~';
      case 'sắc':
        return '/';
      case 'nặng':
        return '.';
      default:
        return '';
    }
  }
}

class VietnameseSpellingDisplayParts {
  const VietnameseSpellingDisplayParts({
    required this.onset,
    required this.rhymeChips,
    required this.toneName,
  });
  final String onset;
  /// Các chip vần (đồng bộ CNGD: `qu` → `oa`, tiếng không âm đầu: `e`,`m`…).
  final List<String> rhymeChips;
  final String toneName;
}

extension VietnameseEducationalSpellingDisplay
    on VietnameseEducationalSpelling {
  static VietnameseSpellingDisplayParts? displayPartsForToken(String token) {
    final String trimmed = token.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final String lettersOnly = _lettersOnlyPreservingCase(trimmed);
    if (lettersOnly.isEmpty) {
      return null;
    }
    final String lower = lettersOnly.toLowerCase();
    final String base = VietnameseEducationalSpelling.stripToneMarks(lower);
    if (base.isEmpty) {
      return null;
    }
    final String onsetLower =
        VietnameseEducationalSpelling._takeOnsetValidated(base);
    final int onsetLength = onsetLower.length;
    if (onsetLength > lettersOnly.length) {
      return null;
    }
    final String onset =
        onsetLength == 0 ? '' : lettersOnly.substring(0, onsetLength);
    final String rhymeTailGraphemes = lettersOnly.substring(onsetLength);
    if (rhymeTailGraphemes.isEmpty) {
      return null;
    }
    final String rhymeNoTone = base.substring(onsetLength);
    final List<String> rhymeChips = _rhymeChipsForDisplay(
      lettersOnly: lettersOnly,
      baseToneless: base,
      onsetLower: onsetLower,
      rhymeNoTone: rhymeNoTone,
      rhymeTailGraphemes: rhymeTailGraphemes,
    );
    if (rhymeChips.isEmpty) {
      return null;
    }
    final String toneName =
        VietnameseEducationalSpelling.detectToneName(lettersOnly);
    return VietnameseSpellingDisplayParts(
      onset: onset,
      rhymeChips: rhymeChips,
      toneName: toneName,
    );
  }

  static List<String> _rhymeChipsForDisplay({
    required String lettersOnly,
    required String baseToneless,
    required String onsetLower,
    required String rhymeNoTone,
    required String rhymeTailGraphemes,
  }) {
    if (onsetLower == 'qu') {
      return <String>[
        VietnameseEducationalSpelling._pedagogyRhymeAfterQu(rhymeNoTone),
      ];
    }
    if (onsetLower.isEmpty) {
      final List<String>? fixed =
          VietnameseEducationalSpelling._zeroOnsetPedagogyChunks[baseToneless];
      if (fixed != null) {
        return List<String>.from(fixed);
      }
      final ({String nucleus, String? coda}) split =
          VietnameseEducationalSpelling._splitNucleusCoda(rhymeNoTone);
      if (split.coda != null &&
          split.nucleus.isNotEmpty &&
          VietnameseEducationalSpelling._codaReadName(split.coda!) != null) {
        return <String>[split.nucleus, split.coda!];
      }
      return <String>[rhymeTailGraphemes];
    }
    return <String>[rhymeTailGraphemes];
  }

  static String _lettersOnlyPreservingCase(String token) {
    final StringBuffer buf = StringBuffer();
    for (final String g in token.characters) {
      if (RegExp(r'^[\p{L}]$', unicode: true).hasMatch(g)) {
        buf.write(g);
      }
    }
    return buf.toString();
  }
}
