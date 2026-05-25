import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'dictionary_constants.dart';

/// Sao chép [DictionaryConstants.bundledAssetPath] ra thư mục app và mở SQLite **read-only**.
///
/// Lần đầu copy ~171MB có thể tốn vài giây — nên gọi từ chỗ có loading (sau này).
/// Dữ liệu: CC BY-SA 4.0 — ghi công trong UI (màn Credits / học ngôn ngữ).
class DictionaryDatabaseManager {
  DictionaryDatabaseManager._();
  static final DictionaryDatabaseManager instance = DictionaryDatabaseManager._();

  Database? _db;

  Future<String> _installedAbsolutePath() async {
    final String dir = await getDatabasesPath();
    return p.join(dir, DictionaryConstants.installedFileName);
  }

  /// Đảm bảo file DB đã có trên disk, khớp [DictionaryConstants.bundledAssetVersion].
  Future<void> ensureInstalled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? installed = prefs.getString(
      DictionaryConstants.prefsInstalledVersionKey,
    );
    final String path = await _installedAbsolutePath();
    final File file = File(path);
    final bool sameVersion =
        installed == DictionaryConstants.bundledAssetVersion;
    final bool fileOk =
        await file.exists() && await file.length() > 4096;
    if (sameVersion && fileOk) {
      return;
    }
    await _db?.close();
    _db = null;
    if (await file.exists()) {
      await file.delete();
    }
    final ByteData data =
        await rootBundle.load(DictionaryConstants.bundledAssetPath);
    final List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await file.writeAsBytes(bytes, flush: true);
    await prefs.setString(
      DictionaryConstants.prefsInstalledVersionKey,
      DictionaryConstants.bundledAssetVersion,
    );
  }

  /// Mở (hoặc tái sử dụng) một [Database] read-only trỏ tới bản đã cài.
  Future<Database> openReadOnly() async {
    await ensureInstalled();
    final String path = await _installedAbsolutePath();
    if (_db != null && _db!.isOpen) {
      return _db!;
    }
    _db = await openDatabase(
      path,
      readOnly: true,
      singleInstance: true,
    );
    return _db!;
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
