import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  // v1: filaments (id, brand, material, color, status)
  // v2: filaments + printer_id + slot
  // v3: printers table
  // v4: locations table + filaments.location_id (RESET)
  static const int _dbVersion = 4;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'filament_manager.db');

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await _onCreate(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _onUpgrade(db, oldVersion);
      },
    );
  }

  Future<void> _onCreate(Database db) async {
    // LOCATIONS
    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // DEFAULT LOCATION (SIGORTA)
    await db.execute('''
      INSERT INTO locations (id, name, is_default)
      VALUES (1, 'DEFAULT', 1)
    ''');

    // FILAMENTS
    await db.execute('''
      CREATE TABLE filaments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT NOT NULL,
        material TEXT NOT NULL,
        color TEXT NOT NULL,
        status TEXT NOT NULL,
        location_id INTEGER NOT NULL DEFAULT 1,
        printer_id INTEGER,
        slot INTEGER
      )
    ''');

    // PRINTERS
    await db.execute('''
      CREATE TABLE printers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        slot_count INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion) async {
    // A3.0 RESET STRATEGY
    // Geliştirme aşamasında temiz reset yapıyoruz
    if (oldVersion < 4) {
      await db.execute('DROP TABLE IF EXISTS filaments');
      await db.execute('DROP TABLE IF EXISTS printers');
      await db.execute('DROP TABLE IF EXISTS locations');

      await _onCreate(db);
    }
  }
}
