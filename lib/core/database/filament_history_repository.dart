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

  /// Add gram update history
  Future<int> addGramUpdate({
    required int filamentId,
    required int gram,
    String? photo,
    String? note,
  }) async {
    final history = FilamentHistory(
      filamentId: filamentId,
      createdAt: DateTime.now(),
      type: HistoryType.gramUpdate,
      gram: gram,
      photo: photo,
      note: note,
    );
    return await addHistory(history);
  }

  /// Record assignment to printer
  Future<int> recordAssignedToPrinter({
    required int filamentId,
    required int oldLocationId,
    required int newPrinterId,
    required int newSlot,
  }) async {
    final history = FilamentHistory(
      filamentId: filamentId,
      createdAt: DateTime.now(),
      type: HistoryType.assignedToPrinter,
      oldLocationId: oldLocationId,
      newPrinterId: newPrinterId,
      newSlot: newSlot,
    );
    return await addHistory(history);
  }

  /// Record unassignment from printer
  Future<int> recordUnassignedFromPrinter({
    required int filamentId,
    required int oldPrinterId,
    required int oldSlot,
    required int newLocationId,
  }) async {
    final history = FilamentHistory(
      filamentId: filamentId,
      createdAt: DateTime.now(),
      type: HistoryType.unassignedFromPrinter,
      oldPrinterId: oldPrinterId,
      oldSlot: oldSlot,
      newLocationId: newLocationId,
    );
    return await addHistory(history);
  }

  /// Record location change (storage to storage)
  Future<int> recordLocationChanged({
    required int filamentId,
    required int oldLocationId,
    required int newLocationId,
  }) async {
    final history = FilamentHistory(
      filamentId: filamentId,
      createdAt: DateTime.now(),
      type: HistoryType.locationChanged,
      oldLocationId: oldLocationId,
      newLocationId: newLocationId,
    );
    return await addHistory(history);
  }

  /// Record slot change (same printer, different slot)
  Future<int> recordSlotChanged({
    required int filamentId,
    required int printerId,
    required int oldSlot,
    required int newSlot,
  }) async {
    final history = FilamentHistory(
      filamentId: filamentId,
      createdAt: DateTime.now(),
      type: HistoryType.slotChanged,
      oldPrinterId: printerId,
      newPrinterId: printerId,
      oldSlot: oldSlot,
      newSlot: newSlot,
    );
    return await addHistory(history);
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

  /// Get only gram update history
  Future<List<FilamentHistory>> getGramHistory(int filamentId) async {
    final db = await _db;
    final maps = await db.query(
      FilamentHistoryTable.tableName,
      where:
          '${FilamentHistoryTable.columnFilamentId} = ? AND ${FilamentHistoryTable.columnType} = ?',
      whereArgs: [filamentId, HistoryType.gramUpdate.name],
      orderBy: '${FilamentHistoryTable.columnCreatedAt} DESC',
    );
    return maps.map((m) => FilamentHistory.fromMap(m)).toList();
  }

  /// Get only movement history
  Future<List<FilamentHistory>> getMovementHistory(int filamentId) async {
    final db = await _db;
    final maps = await db.query(
      FilamentHistoryTable.tableName,
      where:
          '${FilamentHistoryTable.columnFilamentId} = ? AND ${FilamentHistoryTable.columnType} != ?',
      whereArgs: [filamentId, HistoryType.gramUpdate.name],
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

  /// Get latest gram update (for weight tracking)
  Future<FilamentHistory?> getLatestGramUpdate(int filamentId) async {
    final db = await _db;
    final maps = await db.query(
      FilamentHistoryTable.tableName,
      where:
          '${FilamentHistoryTable.columnFilamentId} = ? AND ${FilamentHistoryTable.columnType} = ?',
      whereArgs: [filamentId, HistoryType.gramUpdate.name],
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
