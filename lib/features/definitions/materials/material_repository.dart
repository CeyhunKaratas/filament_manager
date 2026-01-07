import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/database/tables.dart';
import 'material_model.dart';

class MaterialRepository {
  Future<List<MaterialModel>> getAll() async {
    final db = await DatabaseHelper.instance.database;

    final rows = await db.query(
      MaterialTable.tableName,
      orderBy: '${MaterialTable.columnName} ASC',
    );

    return rows.map((e) => MaterialModel.fromMap(e)).toList();
  }

  Future<void> add(String name) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      MaterialTable.tableName,
      {
        MaterialTable.columnName: name,
        MaterialTable.columnIsDefault: 0,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      MaterialTable.tableName,
      where: '${MaterialTable.columnId} = ? AND ${MaterialTable.columnIsDefault} = 0',
      whereArgs: [id],
    );
  }
  
  Future<void> update(int id, String name) async {
  final db = await DatabaseHelper.instance.database;

  await db.update(
    MaterialTable.tableName,
    {
      MaterialTable.columnName: name,
    },
    where: '${MaterialTable.columnId} = ? AND ${MaterialTable.columnIsDefault} = 0',
    whereArgs: [id],
  );
}

}
