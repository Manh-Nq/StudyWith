import 'alphabet_override_image_kind.dart';

class AlphabetLetterOverrideRow {
  const AlphabetLetterOverrideRow({
    required this.letterKey,
    required this.exampleVi,
    required this.exampleEn,
    required this.spellSyllableVi,
    required this.imageKind,
    required this.imageValue,
  });
  final String letterKey;
  final String exampleVi;
  final String exampleEn;
  final String spellSyllableVi;
  final AlphabetOverrideImageKind imageKind;
  final String imageValue;

  factory AlphabetLetterOverrideRow.fromMap(Map<String, Object?> map) {
    return AlphabetLetterOverrideRow(
      letterKey: map['letter_key']! as String,
      exampleVi: map['example_vi']! as String,
      exampleEn: map['example_en']! as String,
      spellSyllableVi: map['spell_syllable_vi']! as String,
      imageKind: AlphabetOverrideImageKind.parse(map['image_kind']! as String),
      imageValue: map['image_value']! as String,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'letter_key': letterKey,
      'example_vi': exampleVi,
      'example_en': exampleEn,
      'spell_syllable_vi': spellSyllableVi,
      'image_kind': imageKind.wireValue,
      'image_value': imageValue,
    };
  }
}
