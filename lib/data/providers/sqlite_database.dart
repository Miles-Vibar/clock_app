import 'package:clock_app/data/models/location.dart';
import 'package:clock_app/resources/strings.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase {
  static final SqliteDatabase instance = SqliteDatabase._internal();

  static Database? _database;

  SqliteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/clock_app.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(SqliteStatements.createTimezones);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(SqliteStatements.dropTimezones);
          await db.execute(SqliteStatements.createTimezones);
        }
      },
    );
  }

  Future<List<Location>> getAllLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> entries = await db.query(Tables.timezone);
    return entries.map((x) => Location.fromJson(x)).toList();
  }

  Future<Location> insertLocation(Location location) async {
    final db = await database;

    return location.copyWith(
      id: await db.insert(Tables.timezone, location.toMap()),
    );
  }

  Future<void> deleteLocation(String location) async {
    final db = await database;

    await db.delete(Tables.timezone, where: 'location = "$location"');
  }
}
