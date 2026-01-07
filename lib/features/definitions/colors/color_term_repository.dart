import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/database/tables.dart';

class ColorTermRepository {
  Future<void> addTerm({
    required int colorId,
    required String term,
    String? lang,
  }) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      ColorTermTable.tableName,
      {
        ColorTermTable.columnColorId: colorId,
        ColorTermTable.columnTerm: term.trim(),
        ColorTermTable.columnLang: lang,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
