import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import '../models/printer.dart';

class PrinterRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Printer>> getAllPrinters() async {
    final db = await _dbHelper.database;

    final result = await db.query('printers', orderBy: 'name COLLATE NOCASE');

    return result.map((e) {
      return Printer(
        id: e['id'] as int,
        name: e['name'] as String,
        slotCount: e['slot_count'] as int,
      );
    }).toList();
  }

  Future<void> insertPrinter(Printer printer) async {
    final db = await _dbHelper.database;

    await db.insert('printers', {
      'name': printer.name,
      'slot_count': printer.slotCount,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Check if printer has any assigned filaments
  Future<int> getAssignedFilamentCount(int printerId) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'filaments',
      where: 'printer_id = ?',
      whereArgs: [printerId],
    );

    return result.length;
  }

  /// Unassign all filaments from a printer and move them to default location
  Future<void> unassignAllFilaments(int printerId) async {
    final db = await _dbHelper.database;

    // Get default location ID
    final locationResult = await db.query(
      'locations',
      where: 'is_default = 1',
      limit: 1,
    );

    if (locationResult.isEmpty) {
      throw Exception('Default location not found');
    }

    final defaultLocationId = locationResult.first['id'] as int;

    // Unassign all filaments from this printer
    await db.update(
      'filaments',
      {'printer_id': null, 'slot': null, 'location_id': defaultLocationId},
      where: 'printer_id = ?',
      whereArgs: [printerId],
    );
  }

  /// Delete printer safely (with option to unassign filaments first)
  Future<void> deletePrinter(
    int printerId, {
    bool unassignFilaments = false,
  }) async {
    final db = await _dbHelper.database;

    if (unassignFilaments) {
      await unassignAllFilaments(printerId);
    }

    await db.delete('printers', where: 'id = ?', whereArgs: [printerId]);
  }
}
