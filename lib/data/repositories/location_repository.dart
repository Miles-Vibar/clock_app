import 'package:clock_app/data/providers/sqlite_database.dart';
import 'package:clock_app/data/models/location.dart';

class LocationRepository {
  final SqliteDatabase _database = SqliteDatabase.instance;

  Future<List<Location>> getAll() async {
    return await _database.getAllLocations();
  }

  Future<Location> insert(String location) async {
    return await _database.insertLocation(Location(location: location));
  }

  Future<void> delete(String location) async {
    await _database.deleteLocation(location);
  }
}