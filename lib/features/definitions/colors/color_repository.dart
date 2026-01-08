import '../../../core/database/database_helper.dart';
import '../../../core/database/tables.dart';
import 'color_model.dart';

class ColorRepository {
  Future<List<ColorModel>> getAll() async {
    final db = await DatabaseHelper.instance.database;

    final rows = await db.query(
      ColorTable.tableName,
      orderBy: '${ColorTable.columnName} ASC',
    );

    return rows.map((e) => ColorModel.fromMap(e)).toList();
  }

  Future<void> add(String name, String? colorCode) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(ColorTable.tableName, {
      ColorTable.columnName: name,
      ColorTable.columnColorCode: colorCode,
      ColorTable.columnIsDefault: 0,
    });
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      ColorTable.tableName,
      where: '${ColorTable.columnId} = ? AND ${ColorTable.columnIsDefault} = 0',
      whereArgs: [id],
    );
  }

  Future<void> update(int id, String name, String? colorCode) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      ColorTable.tableName,
      {ColorTable.columnName: name, ColorTable.columnColorCode: colorCode},
      where: '${ColorTable.columnId} = ? AND ${ColorTable.columnIsDefault} = 0',
      whereArgs: [id],
    );
  }

  Future<ColorModel?> getByName(String name) async {
    final db = await DatabaseHelper.instance.database;

    final rows = await db.query(
      ColorTable.tableName,
      where: 'LOWER(${ColorTable.columnName}) = LOWER(?)',
      whereArgs: [name.trim()],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return ColorModel.fromMap(rows.first);
  }

  Future<ColorModel?> findByNameOrTerm(String input, {String? lang}) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    // 1) direct color name
    final byName = await getByName(trimmed);
    if (byName != null) return byName;

    // 2) color_terms match (alias / other language)
    final db = await DatabaseHelper.instance.database;

    final rows = await db.rawQuery(
      '''
      SELECT c.*
      FROM ${ColorTable.tableName} c
      INNER JOIN ${ColorTermTable.tableName} t
        ON t.${ColorTermTable.columnColorId} = c.${ColorTable.columnId}
      WHERE LOWER(t.${ColorTermTable.columnTerm}) = LOWER(?)
        AND (t.${ColorTermTable.columnLang} IS NULL OR t.${ColorTermTable.columnLang} = ?)
      LIMIT 1
    ''',
      [trimmed, lang],
    );

    if (rows.isEmpty) return null;
    return ColorModel.fromMap(rows.first);
  }
}
