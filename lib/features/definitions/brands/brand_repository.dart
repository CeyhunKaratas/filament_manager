import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/database/tables.dart';
import 'brand_model.dart';

class BrandRepository {
  Future<List<BrandModel>> getAll() async {
    final db = await DatabaseHelper.instance.database;

    final rows = await db.query(
      BrandTable.tableName,
      orderBy: '${BrandTable.columnName} ASC',
    );

    return rows.map((e) => BrandModel.fromMap(e)).toList();
  }

  Future<BrandModel?> getByName(String name) async {
    final db = await DatabaseHelper.instance.database;

    final rows = await db.query(
      BrandTable.tableName,
      where: '${BrandTable.columnName} = ?',
      whereArgs: [name.toLowerCase()],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return BrandModel.fromMap(rows.first);
  }

  Future<void> add(String name) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(BrandTable.tableName, {
      BrandTable.columnName: name,
      BrandTable.columnIsDefault: 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      BrandTable.tableName,
      where: '${BrandTable.columnId} = ? AND ${BrandTable.columnIsDefault} = 0',
      whereArgs: [id],
    );
  }

  Future<void> update(int id, String name) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      BrandTable.tableName,
      {BrandTable.columnName: name},
      where: '${BrandTable.columnId} = ? AND ${BrandTable.columnIsDefault} = 0',
      whereArgs: [id],
    );
  }
}
