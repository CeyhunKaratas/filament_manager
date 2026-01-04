import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../models/location.dart';

class LocationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Tüm location'ları getir
  Future<List<Location>> getAllLocations() async {
    final db = await _dbHelper.database;
    final result = await db.query('locations', orderBy: 'id ASC');

    return result.map((e) => Location.fromMap(e)).toList();
  }

  /// DEFAULT location'ı getir (sigorta)
  Future<Location> getDefaultLocation() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'locations',
      where: 'is_default = 1',
      limit: 1,
    );

    if (result.isEmpty) {
      throw Exception('DEFAULT location not found');
    }

    return Location.fromMap(result.first);
  }

  /// Yeni location ekle (DEFAULT hariç)
  /// Yeni location ekle (DEFAULT hariç)
  Future<int> insertLocation(Location location) async {
    final db = await _dbHelper.database;

    if (location.isDefault) {
      throw Exception('Cannot insert another DEFAULT location');
    }

    return await db.insert('locations', {
      'name': location.name,
      'is_default': location.isDefault ? 1 : 0,
    });
  }

  /// Location sil (DEFAULT silinemez)
  Future<void> deleteLocation(int id) async {
    final db = await _dbHelper.database;

    final defaultLocation = await getDefaultLocation();
    if (id == defaultLocation.id) {
      throw Exception('Cannot delete DEFAULT location');
    }

    // 🔒 A3.1.3 — Filament varsa silme
    final filamentCountResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM filaments WHERE location_id = ?',
      [id],
    );

    final count = Sqflite.firstIntValue(filamentCountResult) ?? 0;
    if (count > 0) {
      throw Exception('Location not empty');
    }

    await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }
}
