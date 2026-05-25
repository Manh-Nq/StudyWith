import 'package:sqflite/sqflite.dart';

import 'alphabet_grade1_data.dart';
import '../model/alphabet_card_view_data.dart';
import '../model/alphabet_letter_override_row.dart';
import '../model/alphabet_override_image_kind.dart';
import 'alphabet_overrides_database.dart';

class AlphabetOverrideRepository {
  AlphabetOverrideRepository({AlphabetOverridesDatabase? db})
      : _db = db ?? AlphabetOverridesDatabase.instance;
  final AlphabetOverridesDatabase _db;

  Future<Map<String, AlphabetLetterOverrideRow>> getAllOverrides() async {
    final Database db = await _db.database();
    final List<Map<String, Object?>> rows =
        await db.query(AlphabetOverridesDatabase.tableName);
    final Map<String, AlphabetLetterOverrideRow> out =
        <String, AlphabetLetterOverrideRow>{};
    for (final Map<String, Object?> row in rows) {
      final AlphabetLetterOverrideRow item =
          AlphabetLetterOverrideRow.fromMap(row);
      out[item.letterKey] = item;
    }
    return out;
  }

  Future<AlphabetLetterOverrideRow?> getOverride(String letterKey) async {
    final Database db = await _db.database();
    final List<Map<String, Object?>> rows = await db.query(
      AlphabetOverridesDatabase.tableName,
      where: 'letter_key = ?',
      whereArgs: <Object>[letterKey],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return AlphabetLetterOverrideRow.fromMap(rows.first);
  }

  Future<void> upsert(AlphabetLetterOverrideRow row) async {
    final Database db = await _db.database();
    await db.insert(
      AlphabetOverridesDatabase.tableName,
      row.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String letterKey) async {
    final Database db = await _db.database();
    await db.delete(
      AlphabetOverridesDatabase.tableName,
      where: 'letter_key = ?',
      whereArgs: <Object>[letterKey],
    );
  }

  AlphabetCardViewData mergeCard(
    AlphabetGrade1Card base,
    Map<String, AlphabetLetterOverrideRow> overrides,
  ) {
    final AlphabetLetterOverrideRow? ovr = overrides[base.letterDisplay];
    if (ovr == null) {
      return AlphabetCardViewData(
        base: base,
        exampleVi: base.exampleVi,
        exampleEn: base.exampleEn,
        spellSyllableVi: base.spellSyllableVi,
        imageKind: AlphabetOverrideImageKind.icon,
        imageValue: '',
      );
    }
    return AlphabetCardViewData(
      base: base,
      exampleVi: ovr.exampleVi,
      exampleEn: ovr.exampleEn,
      spellSyllableVi: ovr.spellSyllableVi,
      imageKind: ovr.imageKind,
      imageValue: ovr.imageValue,
    );
  }

  Future<List<AlphabetCardViewData>> loadAllViewData() async {
    final Map<String, AlphabetLetterOverrideRow> map = await getAllOverrides();
    return AlphabetGrade1Data.cards
        .map(
          (AlphabetGrade1Card base) => mergeCard(base, map),
        )
        .toList();
  }
}
