import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class MathLocalDatabase {
  MathLocalDatabase._();
  static final MathLocalDatabase instance = MathLocalDatabase._();
  static const String _dbName = 'math_thinking.db';
  static const int _dbVersion = 2;
  static const String entityTable = 'math_entity_types';
  Database? _db;

  Future<Database> database() async {
    if (_db != null) {
      return _db!;
    }
    final String dbPath = await getDatabasesPath();
    final String path = p.join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $entityTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            image_kind TEXT NOT NULL,
            image_value TEXT NOT NULL,
            is_active INTEGER NOT NULL DEFAULT 1,
            created_at_epoch_ms INTEGER NOT NULL,
            updated_at_epoch_ms INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE $entityTable ADD COLUMN image_kind TEXT NOT NULL DEFAULT 'url'",
          );
          await db.execute(
            "ALTER TABLE $entityTable ADD COLUMN image_value TEXT NOT NULL DEFAULT ''",
          );
          await db.execute(
            "UPDATE $entityTable SET image_value = image_url WHERE image_value = ''",
          );
        }
      },
    );
    return _db!;
  }
}
