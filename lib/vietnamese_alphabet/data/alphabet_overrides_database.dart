import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AlphabetOverridesDatabase {
  AlphabetOverridesDatabase._();
  static final AlphabetOverridesDatabase instance = AlphabetOverridesDatabase._();
  static const String _dbName = 'alphabet_overrides.db';
  static const int _dbVersion = 1;
  static const String tableName = 'alphabet_letter_overrides';
  Database? _db;

  Future<Database> database() async {
    if (_db != null) {
      return _db!;
    }
    final String dir = await getDatabasesPath();
    final String path = p.join(dir, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
CREATE TABLE $tableName (
  letter_key TEXT PRIMARY KEY,
  example_vi TEXT NOT NULL,
  example_en TEXT NOT NULL,
  spell_syllable_vi TEXT NOT NULL,
  image_kind TEXT NOT NULL,
  image_value TEXT NOT NULL
)
''');
      },
    );
    return _db!;
  }
}
