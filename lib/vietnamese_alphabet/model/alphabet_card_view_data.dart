import '../data/alphabet_grade1_data.dart';
import 'alphabet_override_image_kind.dart';

/// Dữ liệu hiển thị một thẻ chữ sau khi gộp bản gốc + ghi đè SQLite (nếu có).
class AlphabetCardViewData {
  const AlphabetCardViewData({
    required this.base,
    required this.exampleVi,
    required this.exampleEn,
    required this.spellSyllableVi,
    required this.imageKind,
    required this.imageValue,
  });
  final AlphabetGrade1Card base;
  final String exampleVi;
  final String exampleEn;
  final String spellSyllableVi;
  final AlphabetOverrideImageKind imageKind;
  final String imageValue;

  String get letterDisplay => base.letterDisplay;
}
