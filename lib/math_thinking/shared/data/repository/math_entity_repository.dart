import '../../model/math_entity_type.dart';
import '../local/math_local_database.dart';

class MathEntityRepository {
  MathEntityRepository({MathLocalDatabase? db})
      : _db = db ?? MathLocalDatabase.instance;
  final MathLocalDatabase _db;
  bool _useMemoryFallback = false;
  int _memoryIdCursor = 1000;
  List<MathEntityType> _memoryEntities = <MathEntityType>[];

  Future<void> ensureSeedData() async {
    try {
      final List<MathEntityType> items = await getAll();
      if (items.isNotEmpty) {
        final bool needsReplaceOldDefaults = items.every((MathEntityType item) {
          const Set<String> oldNames = <String>{'Táo', 'Cam', 'Lê', 'Gà', 'Bò'};
          return oldNames.contains(item.name) &&
              item.imageKind == MathEntityImageKind.url;
        });
        if (needsReplaceOldDefaults) {
          final db = await _db.database();
          await db.delete(MathLocalDatabase.entityTable);
          final int now = DateTime.now().millisecondsSinceEpoch;
          final List<Map<String, Object?>> seeds = _defaultSeedRows(now);
          for (final Map<String, Object?> item in seeds) {
            await db.insert(MathLocalDatabase.entityTable, item);
          }
        }
        return;
      }
      final int now = DateTime.now().millisecondsSinceEpoch;
      final List<Map<String, Object?>> seeds = _defaultSeedRows(now);
      final db = await _db.database();
      for (final Map<String, Object?> item in seeds) {
        await db.insert(MathLocalDatabase.entityTable, item);
      }
    } catch (_) {
      _activateMemoryFallbackIfNeeded();
    }
  }

  Future<List<MathEntityType>> getAll() async {
    if (_useMemoryFallback) {
      _activateMemoryFallbackIfNeeded();
      return List<MathEntityType>.from(_memoryEntities);
    }
    try {
      final db = await _db.database();
      final List<Map<String, Object?>> rows = await db.query(
        MathLocalDatabase.entityTable,
        orderBy: 'id DESC',
      );
      return rows.map(MathEntityType.fromMap).toList();
    } catch (_) {
      _activateMemoryFallbackIfNeeded();
      return List<MathEntityType>.from(_memoryEntities);
    }
  }

  Future<List<MathEntityType>> getActive() async {
    if (_useMemoryFallback) {
      _activateMemoryFallbackIfNeeded();
      return _memoryEntities
          .where((MathEntityType item) => item.isActive)
          .toList();
    }
    try {
      final db = await _db.database();
      final List<Map<String, Object?>> rows = await db.query(
        MathLocalDatabase.entityTable,
        where: 'is_active = ?',
        whereArgs: <Object>[1],
        orderBy: 'id DESC',
      );
      return rows.map(MathEntityType.fromMap).toList();
    } catch (_) {
      _activateMemoryFallbackIfNeeded();
      return _memoryEntities
          .where((MathEntityType item) => item.isActive)
          .toList();
    }
  }

  Future<void> addEntity({
    required String name,
    required MathEntityImageKind imageKind,
    required String imageValue,
  }) async {
    final String trimmedName = name.trim();
    final String trimmedImageValue = imageValue.trim();
    if (_useMemoryFallback) {
      _addToMemory(trimmedName, imageKind, trimmedImageValue);
      return;
    }
    final int now = DateTime.now().millisecondsSinceEpoch;
    try {
      final db = await _db.database();
      await db.insert(MathLocalDatabase.entityTable, <String, Object?>{
        'name': trimmedName,
        'image_kind': _imageKindToDbValue(imageKind),
        'image_value': trimmedImageValue,
        'is_active': 1,
        'created_at_epoch_ms': now,
        'updated_at_epoch_ms': now,
      });
    } catch (_) {
      _activateMemoryFallbackIfNeeded();
      _addToMemory(trimmedName, imageKind, trimmedImageValue);
    }
  }

  Future<void> setActive({required int id, required bool isActive}) async {
    if (_useMemoryFallback) {
      _updateMemoryActive(id, isActive);
      return;
    }
    try {
      final db = await _db.database();
      await db.update(
        MathLocalDatabase.entityTable,
        <String, Object?>{
          'is_active': isActive ? 1 : 0,
          'updated_at_epoch_ms': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: <Object>[id],
      );
    } catch (_) {
      _activateMemoryFallbackIfNeeded();
      _updateMemoryActive(id, isActive);
    }
  }

  Future<void> delete(int id) async {
    if (_useMemoryFallback) {
      _memoryEntities = _memoryEntities
          .where((MathEntityType item) => item.id != id)
          .toList();
      return;
    }
    try {
      final db = await _db.database();
      await db.delete(
        MathLocalDatabase.entityTable,
        where: 'id = ?',
        whereArgs: <Object>[id],
      );
    } catch (_) {
      _activateMemoryFallbackIfNeeded();
      _memoryEntities = _memoryEntities
          .where((MathEntityType item) => item.id != id)
          .toList();
    }
  }

  void _activateMemoryFallbackIfNeeded() {
    _useMemoryFallback = true;
    if (_memoryEntities.isNotEmpty) {
      return;
    }
    final int now = DateTime.now().millisecondsSinceEpoch;
    _memoryEntities = <MathEntityType>[
      MathEntityType(
        id: _memoryIdCursor++,
        name: 'Hình tròn',
        imageKind: MathEntityImageKind.vector,
        imageValue: 'circle',
        isActive: true,
        createdAtEpochMs: now,
        updatedAtEpochMs: now,
      ),
      MathEntityType(
        id: _memoryIdCursor++,
        name: 'Hình vuông',
        imageKind: MathEntityImageKind.vector,
        imageValue: 'square',
        isActive: true,
        createdAtEpochMs: now,
        updatedAtEpochMs: now,
      ),
      MathEntityType(
        id: _memoryIdCursor++,
        name: 'Hình chữ nhật',
        imageKind: MathEntityImageKind.vector,
        imageValue: 'rectangle',
        isActive: true,
        createdAtEpochMs: now,
        updatedAtEpochMs: now,
      ),
      MathEntityType(
        id: _memoryIdCursor++,
        name: 'Hình tam giác',
        imageKind: MathEntityImageKind.vector,
        imageValue: 'triangle',
        isActive: true,
        createdAtEpochMs: now,
        updatedAtEpochMs: now,
      ),
      MathEntityType(
        id: _memoryIdCursor++,
        name: 'Hình ngôi sao',
        imageKind: MathEntityImageKind.vector,
        imageValue: 'star',
        isActive: true,
        createdAtEpochMs: now,
        updatedAtEpochMs: now,
      ),
    ];
  }

  void _addToMemory(
      String name, MathEntityImageKind imageKind, String imageValue) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    _memoryEntities = <MathEntityType>[
      MathEntityType(
        id: _memoryIdCursor++,
        name: name,
        imageKind: imageKind,
        imageValue: imageValue,
        isActive: true,
        createdAtEpochMs: now,
        updatedAtEpochMs: now,
      ),
      ..._memoryEntities,
    ];
  }

  void _updateMemoryActive(int id, bool isActive) {
    _memoryEntities = _memoryEntities.map((MathEntityType item) {
      if (item.id != id) {
        return item;
      }
      return item.copyWith(
        isActive: isActive,
        updatedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
      );
    }).toList();
  }

  List<Map<String, Object?>> _defaultSeedRows(int now) {
    return <Map<String, Object?>>[
      <String, Object?>{
        'name': 'Hình tròn',
        'image_kind': 'vector',
        'image_value': 'circle',
        'is_active': 1,
        'created_at_epoch_ms': now,
        'updated_at_epoch_ms': now,
      },
      <String, Object?>{
        'name': 'Hình vuông',
        'image_kind': 'vector',
        'image_value': 'square',
        'is_active': 1,
        'created_at_epoch_ms': now,
        'updated_at_epoch_ms': now,
      },
      <String, Object?>{
        'name': 'Hình chữ nhật',
        'image_kind': 'vector',
        'image_value': 'rectangle',
        'is_active': 1,
        'created_at_epoch_ms': now,
        'updated_at_epoch_ms': now,
      },
      <String, Object?>{
        'name': 'Hình tam giác',
        'image_kind': 'vector',
        'image_value': 'triangle',
        'is_active': 1,
        'created_at_epoch_ms': now,
        'updated_at_epoch_ms': now,
      },
      <String, Object?>{
        'name': 'Hình ngôi sao',
        'image_kind': 'vector',
        'image_value': 'star',
        'is_active': 1,
        'created_at_epoch_ms': now,
        'updated_at_epoch_ms': now,
      },
    ];
  }

  String _imageKindToDbValue(MathEntityImageKind kind) {
    switch (kind) {
      case MathEntityImageKind.vector:
        return 'vector';
      case MathEntityImageKind.base64:
        return 'base64';
      case MathEntityImageKind.url:
        return 'url';
    }
  }
}
