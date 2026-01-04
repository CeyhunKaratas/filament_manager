import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import '../models/printer.dart';

class PrinterRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Printer>> getAllPrinters() async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'printers',
      orderBy: 'name COLLATE NOCASE',
    );

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

    await db.insert(
      'printers',
      {
        'name': printer.name,
        'slot_count': printer.slotCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePrinter(int printerId) async {
    final db = await _dbHelper.database;

    await db.delete(
      'printers',
      where: 'id = ?',
      whereArgs: [printerId],
    );
  }
}
