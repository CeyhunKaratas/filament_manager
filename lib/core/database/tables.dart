class FilamentTable {
  static const tableName = 'filaments';

  static const columnId = 'id';
  static const columnBrand = 'brand';
  static const columnMaterial = 'material';
  static const columnColor = 'color';
  static const columnInitialWeight = 'initial_weight';
  static const columnRemainingWeight = 'remaining_weight';
  static const columnStatus = 'status';
  static const columnNotes = 'notes';

  static const createTable = '''
  CREATE TABLE $tableName (
    $columnId TEXT PRIMARY KEY,
    $columnBrand TEXT NOT NULL,
    $columnMaterial TEXT NOT NULL,
    $columnColor TEXT NOT NULL,
    $columnInitialWeight REAL,
    $columnRemainingWeight REAL,
    $columnStatus TEXT NOT NULL,
    $columnNotes TEXT
  )
  ''';
}
