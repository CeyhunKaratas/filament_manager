import 'package:sqflite/sqflite.dart';

import '../models/filament.dart';
import '../models/filament_material.dart';
import 'database_helper.dart';

class SlotOccupiedException implements Exception {
  final int printerId;
  final int slot;
  final int occupyingFilamentId;

  SlotOccupiedException({
    required this.printerId,
    required this.slot,
    required this.occupyingFilamentId,
  });

  @override
  String toString() =>
      'SlotOccupiedException(printerId: $printerId, slot: $slot, occupyingFilamentId: $occupyingFilamentId)';
}

class FilamentRepository {
  Future<Database> get _db async => DatabaseHelper.instance.database;

  Future<List<Filament>> getAllFilaments() async {
    final db = await _db;
    final result = await db.query('filaments');

    return result.map<Filament>((map) {
      return Filament(
        id: map['id'] as int,
        brand: map['brand'] as String,
        material: FilamentMaterial.values.firstWhere(
          (e) => e.name == map['material'],
        ),
        color: map['color'] as String,
        status: FilamentStatus.values.firstWhere(
          (e) => e.name == map['status'],
        ),
        locationId: map['location_id'] as int,
        printerId: map['printer_id'] as int?, // ✅
        slot: map['slot'] as int?, // ✅
      );
    }).toList();
  }

  Future<List<Filament>> getFilamentsByPrinter(int printerId) async {
    final db = await _db;

    final result = await db.query(
      'filaments',
      where: 'printer_id = ?',
      whereArgs: [printerId],
    );

    return result.map((map) {
      return Filament(
        id: map['id'] as int,
        brand: map['brand'] as String,
        material: FilamentMaterial.values.firstWhere(
          (e) => e.name == map['material'],
        ),
        color: map['color'] as String,
        status: FilamentStatus.values.firstWhere(
          (e) => e.name == map['status'],
        ),
        locationId: map['location_id'] as int,
        printerId: map['printer_id'] as int?,
        slot: map['slot'] as int?,
      );
    }).toList();
  }

  Future<void> insertFilament(Filament filament) async {
    final db = await _db;
    await db.insert('filaments', {
      'brand': filament.brand,
      'material': filament.material.name,
      'color': filament.color,
      'status': filament.status.name,
    });
  }

  Future<void> deleteFilament(int id) async {
    final db = await _db;
    await db.delete('filaments', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateFilament(Filament filament) async {
    final db = await _db;
    await db.update(
      'filaments',
      {
        'brand': filament.brand,
        'material': filament.material.name,
        'color': filament.color,
        'status': filament.status.name,
        'printer_id': filament.printerId,
        'slot': filament.slot,
        'location_id': filament.locationId,
      },
      where: 'id = ?',
      whereArgs: [filament.id],
    );
  }

  Future<List<String>> getDistinctValues(String column) async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.rawQuery(
      'SELECT DISTINCT $column FROM filaments WHERE $column IS NOT NULL',
    );
    return res.map((e) => e[column] as String).toList();
  }

  Future<bool> isSlotOccupied({
    required int printerId,
    required int slot,
    required int excludeFilamentId,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'filaments',
      where: 'printer_id = ? AND slot = ? AND id != ?',
      whereArgs: [printerId, slot, excludeFilamentId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<void> assignFilament(
    int filamentId,
    int printerId,
    int slot, {
    bool force = false,
  }) async {
    final db = await _db;

    await db.transaction((txn) async {
      // 1) Slot dolu mu? (aynı filament hariç)
      final existing = await txn.query(
        'filaments',
        columns: ['id'],
        where: 'printer_id = ? AND slot = ? AND id != ?',
        whereArgs: [printerId, slot, filamentId],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        final occupyingId = existing.first['id'] as int;

        // UI confirmation yoksa burada exception ile akışı durduracağız.
        if (!force) {
          throw SlotOccupiedException(
            printerId: printerId,
            slot: slot,
            occupyingFilamentId: occupyingId,
          );
        }

        // force=true ise: o slotta olan HER ŞEYİ boşalt (tek slotta tek makara kuralı)
        await txn.update(
          'filaments',
          {'printer_id': null, 'slot': null},
          where: 'printer_id = ? AND slot = ?',
          whereArgs: [printerId, slot],
        );
      }

      // 2) Hedef filament'i bu slota ata
      await txn.update(
        'filaments',
        {'printer_id': printerId, 'slot': slot},
        where: 'id = ?',
        whereArgs: [filamentId],
      );
    });
  }

  Future<void> unassignFilament(int filamentId) async {
    final db = await _db;

    await db.update(
      'filaments',
      {'printer_id': null, 'slot': null},
      where: 'id = ?',
      whereArgs: [filamentId],
    );
  }

  Future<int> countFilamentsByLocation(int locationId) async {
    final db = await _db;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM filaments WHERE location_id = ?',
      [locationId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> unassignFilamentToLocation({
    required int filamentId,
    required int locationId,
  }) async {
    final db = await _db;

    await db.update(
      'filaments',
      {'printer_id': null, 'slot': null, 'location_id': locationId},
      where: 'id = ?',
      whereArgs: [filamentId],
    );
  }
}
