import 'package:sqflite/sqflite.dart';
import '../models/filament_history.dart';
import 'database_helper.dart';
import 'tables.dart';

class FilamentHistoryRepository {
  Future<Database> get _db async => DatabaseHelper.instance.database;

  /// Add new history record
  Future<int> addHistory(FilamentHistory history) async {
    final db = await _db;
    return await db.insert(FilamentHistoryTable.tableName, history.toMap());
  }

  /// Get all history for a filament (ordered by date, newest first)
  Future<List<FilamentHistory>> getHistoryForFilament(int filamentId) async {
    final db = await _db;
    final maps = await db.query(
      FilamentHistoryTable.tableName,
      where: '${FilamentHistoryTable.columnFilamentId} = ?',
      whereArgs: [filamentId],
      orderBy: '${FilamentHistoryTable.columnCreatedAt} DESC',
    );
    return maps.map((m) => FilamentHistory.fromMap(m)).toList();
  }

  /// Get initial (first) history record for a filament
  Future<FilamentHistory?> getInitialHistory(int filamentId) async {
    final db = await _db;
    final maps = await db.query(
      FilamentHistoryTable.tableName,
      where: '${FilamentHistoryTable.columnFilamentId} = ?',
      whereArgs: [filamentId],
      orderBy: '${FilamentHistoryTable.columnCreatedAt} ASC',
      limit: 1,
    );
    return maps.isEmpty ? null : FilamentHistory.fromMap(maps.first);
  }

  /// Get latest (most recent) history record for a filament
  Future<FilamentHistory?> getLatestHistory(int filamentId) async {
    final db = await _db;
    final maps = await db.query(
      FilamentHistoryTable.tableName,
      where: '${FilamentHistoryTable.columnFilamentId} = ?',
      whereArgs: [filamentId],
      orderBy: '${FilamentHistoryTable.columnCreatedAt} DESC',
      limit: 1,
    );
    return maps.isEmpty ? null : FilamentHistory.fromMap(maps.first);
  }

  /// Delete all history for a filament (CASCADE should handle this, but just in case)
  Future<int> deleteHistoryForFilament(int filamentId) async {
    final db = await _db;
    return await db.delete(
      FilamentHistoryTable.tableName,
      where: '${FilamentHistoryTable.columnFilamentId} = ?',
      whereArgs: [filamentId],
    );
  }
}
