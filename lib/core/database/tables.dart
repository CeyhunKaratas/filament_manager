class FilamentTable {
  static const tableName = 'filaments';

  static const columnId = 'id';
  static const columnBrandId = 'brand_id';
  static const columnMaterialId = 'material_id';
  static const columnColorId = 'color_id';
  static const columnInitialWeight = 'initial_weight';
  static const columnRemainingWeight = 'remaining_weight';
  static const columnStatus = 'status';
  static const columnLocationId = 'location_id';
  static const columnPrinterId = 'printer_id';
  static const columnSlot = 'slot';
  static const columnMainPhotoPath = 'main_photo_path';
  static const columnNotes = 'notes';

  static const createTable =
      '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnBrandId INTEGER NOT NULL,
    $columnMaterialId INTEGER NOT NULL,
    $columnColorId INTEGER NOT NULL,
    $columnInitialWeight REAL,
    $columnRemainingWeight REAL,
    $columnStatus TEXT NOT NULL,
    $columnLocationId INTEGER NOT NULL,
    $columnPrinterId INTEGER,
    $columnSlot INTEGER,
    $columnMainPhotoPath TEXT,
    $columnNotes TEXT
  )
  ''';
}

class ColorTable {
  static const tableName = 'colors';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnColorCode = 'color_code';
  static const columnIsDefault = 'is_default';

  static const createTable =
      '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL UNIQUE,
    $columnColorCode TEXT,
    $columnIsDefault INTEGER NOT NULL DEFAULT 0
  )
  ''';
}

class ColorTermTable {
  static const tableName = 'color_terms';

  static const columnId = 'id';
  static const columnColorId = 'color_id';
  static const columnTerm = 'term';
  static const columnLang = 'lang';

  static const createTable =
      '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnColorId INTEGER NOT NULL,
    $columnTerm TEXT NOT NULL,
    $columnLang TEXT,
    UNIQUE($columnColorId, $columnTerm, $columnLang)
  )
  ''';
}

class BrandTable {
  static const tableName = 'brands';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnIsDefault = 'is_default';

  static const createTable =
      '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL UNIQUE,
    $columnIsDefault INTEGER NOT NULL DEFAULT 0
  )
  ''';
}

class MaterialTable {
  static const tableName = 'materials';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnIsDefault = 'is_default';

  static const createTable =
      '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL UNIQUE,
    $columnIsDefault INTEGER NOT NULL DEFAULT 0
  )
  ''';
}

class LocationTable {
  static const tableName = 'locations';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnIsDefault = 'is_default';

  static const createTable =
      '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL UNIQUE,
    $columnIsDefault INTEGER NOT NULL DEFAULT 0
  )
  ''';
}

class PrinterTable {
  static const tableName = 'printers';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnSlotCount = 'slot_count';

  static const createTable =
      '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL UNIQUE,
    $columnSlotCount INTEGER NOT NULL
  )
  ''';
}

class FilamentHistoryTable {
  static const tableName = 'filament_history';

  // Primary fields
  static const columnId = 'id';
  static const columnFilamentId = 'filament_id';
  static const columnCreatedAt = 'created_at';
  static const columnType = 'type';

  // Gram tracking (optional for movement-only records)
  static const columnGram = 'gram';
  static const columnPhoto = 'photo';
  static const columnNote = 'note';

  // Movement tracking (optional for gram-only records)
  static const columnOldLocationId = 'old_location_id';
  static const columnNewLocationId = 'new_location_id';
  static const columnOldPrinterId = 'old_printer_id';
  static const columnNewPrinterId = 'new_printer_id';
  static const columnOldSlot = 'old_slot';
  static const columnNewSlot = 'new_slot';

  static const createTable =
      '''
  CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnFilamentId INTEGER NOT NULL,
    $columnCreatedAt TEXT NOT NULL,
    $columnType TEXT NOT NULL DEFAULT 'gramUpdate',
    $columnGram INTEGER,
    $columnPhoto TEXT,
    $columnNote TEXT,
    $columnOldLocationId INTEGER,
    $columnNewLocationId INTEGER,
    $columnOldPrinterId INTEGER,
    $columnNewPrinterId INTEGER,
    $columnOldSlot INTEGER,
    $columnNewSlot INTEGER,
    FOREIGN KEY ($columnFilamentId) REFERENCES ${FilamentTable.tableName}(${FilamentTable.columnId}) ON DELETE CASCADE
  )
  ''';
}
