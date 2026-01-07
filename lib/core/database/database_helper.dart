import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  // v1: basic filaments
  // v2: printers
  // v3: slots
  // v4: locations (reset)
  // v5: colors / color_terms / brands / materials (reset)
  // v6: lower case
  static Database? _database;
  static const int _dbVersion = 6;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'filament_manager.db');

    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, _) async => _onCreate(db),
      onUpgrade: (db, oldV, _) async => _onUpgrade(db, oldV),
    );
    return _database!;
  }

  Future<void> _onCreate(Database db) async {
    await db.execute(ColorTable.createTable);
    await db.execute(ColorTermTable.createTable);
    await db.execute(BrandTable.createTable);
    await db.execute(MaterialTable.createTable);
    await db.execute(LocationTable.createTable);
    await db.execute(PrinterTable.createTable);
    await db.execute(FilamentTable.createTable);

    await _seedDefaultLocation(db);
    await _seedDefaultColors(db);
    await _seedDefaultColorTerms(db);
    await _seedDefaultBrands(db);
    await _seedDefaultMaterials(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion) async {
    if (oldVersion < 5) {
      await db.execute('DROP TABLE IF EXISTS filaments');
      await db.execute('DROP TABLE IF EXISTS printers');
      await db.execute('DROP TABLE IF EXISTS locations');
      await db.execute('DROP TABLE IF EXISTS colors');
      await db.execute('DROP TABLE IF EXISTS color_terms');
      await db.execute('DROP TABLE IF EXISTS brands');
      await db.execute('DROP TABLE IF EXISTS materials');
      await _onCreate(db);
    }
  }

  // =========================
  // SEED (ALL LOWERCASE)
  // =========================

  Future<void> _seedDefaultLocation(Database db) async {
    await db.insert(
      LocationTable.tableName,
      {
        LocationTable.columnId: 1,
        LocationTable.columnName: 'default',
        LocationTable.columnIsDefault: 1,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // ---------------- COLORS ----------------

  Future<void> _seedDefaultColors(Database db) async {
    final colors = [
      [1,'white','#ffffff'],[2,'black','#000000'],[3,'grey','#808080'],
      [4,'silver','#c0c0c0'],[5,'yellow','#ffd700'],[6,'gold','#d4af37'],
      [7,'orange','#ff8c00'],[8,'red','#ff0000'],[9,'red_dark','#8b0000'],
      [10,'green','#00aa00'],[11,'green_lime','#32cd32'],[12,'green_dark','#006400'],
      [13,'blue','#0000ff'],[14,'blue_navy','#000080'],[15,'blue_dark','#00008b'],
      [16,'purple','#800080'],[17,'pink','#ff69b4'],[18,'magenta','#ff00ff'],
      [19,'brown','#8b4513'],[20,'wood',null],
      [21,'transparent',null],[22,'natural',null],
      [23,'neon_green','#39ff14'],[24,'neon_orange','#ff5f1f'],
      [25,'glow_green',null],[26,'glow_blue',null],
      [27,'marble_white',null],[28,'marble_black',null],
      [29,'carbon_black',null],
    ];

    for (final c in colors) {
      await db.insert(
        ColorTable.tableName,
        {
          ColorTable.columnId: c[0],
          ColorTable.columnName: c[1],
          ColorTable.columnColorCode: c[2],
          ColorTable.columnIsDefault: 1,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // ---------------- COLOR TERMS ----------------

  Future<void> _seedDefaultColorTerms(Database db) async {
    final terms = [
      [1,'white','en'],[1,'weiß','de'],[1,'beyaz','tr'],[1,'blanc','fr'],
      [1,'bianco','it'],[1,'blanco','es'],[1,'biały','pl'],
      [1,'wit','nl'],[1,'bílá','cz'],[1,'biela','sk'],

      [2,'black','en'],[2,'schwarz','de'],[2,'siyah','tr'],[2,'noir','fr'],
      [2,'nero','it'],[2,'negro','es'],[2,'czarny','pl'],
      [2,'zwart','nl'],[2,'černá','cz'],[2,'čierna','sk'],

      [3,'grey','en'],[3,'grau','de'],[3,'gri','tr'],[3,'gris','fr'],
      [3,'grigio','it'],[3,'gris','es'],[3,'szary','pl'],
      [3,'grijs','nl'],[3,'šedá','cz'],[3,'sivá','sk'],

      [5,'yellow','en'],[5,'gelb','de'],[5,'sarı','tr'],[5,'jaune','fr'],
      [6,'gold',null],[6,'golden',null],[6,'altın','tr'],

      [8,'red','en'],[8,'rot','de'],[8,'kırmızı','tr'],[8,'rouge','fr'],
      [9,'dark red','en'],

      [10,'green','en'],[10,'grün','de'],[10,'yeşil','tr'],
      [11,'lime',null],[23,'neon green',null],

      [13,'blue','en'],[13,'blau','de'],[13,'mavi','tr'],
      [14,'navy',null],

      [21,'transparent',null],[22,'natural',null],
      [25,'glow',null],[29,'carbon',null],
    ];

    for (final t in terms) {
      await db.insert(
        ColorTermTable.tableName,
        {
          ColorTermTable.columnColorId: t[0],
          ColorTermTable.columnTerm: t[1],
          ColorTermTable.columnLang: t[2],
        },
      );
    }
  }

  // ---------------- BRANDS ----------------

  Future<void> _seedDefaultBrands(Database db) async {
    final brands = [
      'generic','no-name',
      'prusament','polymaker','colorfabb','fillamentum','fiberlogy',
      'extrudr','formfutura','spectrum filaments','basf ultrafuse',
      'protopasta','kimya','3dxtech',
      'esun','sunlu','overture','hatchbox','inland','amolen',
      'eryone','giantarm','ziro','cc3d','yousu','tecbears','jayo',
      'creality','anycubic','bambu lab','elegoo','flashforge',
      'qidi','raise3d','ultimaker','makerbot',
      '3djake','primacreator','devil design','azurefilm','monoprice'
    ];

    for (final b in brands) {
      await db.insert(
        BrandTable.tableName,
        {
          BrandTable.columnName: b,
          BrandTable.columnIsDefault: 1,
        },
      );
    }
  }

  // ---------------- MATERIALS ----------------

  Future<void> _seedDefaultMaterials(Database db) async {
    final materials = [
      'pla','pla+','pla pro','silk pla','matte pla',
      'cf-pla','petg','cf-petg','abs','asa',
      'tpu','tpe','nylon','pa6','pa12',
      'pc','pc-abs','hips','pva','bvoh',
    ];

    for (final m in materials) {
      await db.insert(
        MaterialTable.tableName,
        {
          MaterialTable.columnName: m,
          MaterialTable.columnIsDefault: 1,
        },
      );
    }
  }
}
