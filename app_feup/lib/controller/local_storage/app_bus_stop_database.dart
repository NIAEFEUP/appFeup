import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:uni/model/entities/bus_stop.dart';

/// Manages the app's Bus Stops database.
/// 
/// This database stores information about the bus stops that the user
/// wants to keep track of. It also stores information about
/// which ones are the user's favorite stops.
class AppBusStopDatabase extends AppDatabase {
  AppBusStopDatabase()
      : super('busstops.db', [
          'CREATE TABLE busstops(stopCode TEXT, busCode TEXT)',
          'CREATE TABLE favoritestops(stopCode TEXT, favorited TEXT)'
        ]);

  /// Returns a map containing all the data available in this database.
  /// 
  /// *Note:*
  /// * a key in this map is a bus stop's `stopCode`.
  /// * a value in this map is the corresponding [BusStopData] instance.
  Future<Map<String, BusStopData>> busStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for all bus stops
    final List<Map<String, dynamic>> buses = await db.query('busstops');

    final List<Map<String, dynamic>> favoritesQueryResult =
        await db.query('favoritestops');

    final Map<String, bool> favorites =  Map();
    favoritesQueryResult
        .forEach((e) => favorites[e['stopCode']] = e['favorited'] == '1');

    final Map<String, BusStopData> stops =  Map();
    groupBy(buses, (stop) => stop['stopCode']).forEach(
        (stopCode, busCodeList) => stops[stopCode] = BusStopData(
            configuredBuses:  Set<String>.from(
                busCodeList.map((busEntry) => busEntry['busCode'])),
            favorited: favorites[stopCode]));
    return stops;
  }

  /// Toggles whether or not a bus stop is considered a user's favorite.
  Future<void> updateFavoriteBusStop(String stopCode) async {
    final Map<String, BusStopData> stops = await busStops();
    stops[stopCode].favorited = !stops[stopCode].favorited;
    await deleteBusStops();
    await _insertBusStops(stops);
  }

  /// Adds a bus stop to this database.
  Future<void> addBusStop(String stopCode, BusStopData stopData) async {
    final Map<String, BusStopData> stops = await busStops();
    stops[stopCode] = stopData;
    await deleteBusStops();
    await _insertBusStops(stops);
  }

  /// Removes a bus stop from this database.
  Future<void> removeBusStop(String stopCode) async {
    final Map<String, BusStopData> stops = await busStops();
    stops.remove(stopCode);
    await deleteBusStops();
    await _insertBusStops(stops);
  }

  /// Adds all entries from [stops] to this database.
  /// 
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertBusStops(Map<String, BusStopData> stops) async {
    stops.forEach((stopCode, stopData) async {
      await insertInDatabase('favoritestops',
          {'stopCode': stopCode, 'favorited': stopData.favorited});
      stopData.configuredBuses.forEach((busCode) async {
        await insertInDatabase(
          'busstops',
          {
            'stopCode': stopCode,
            'busCode': busCode,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    });
  }

  // TODO Should this doc be more specific or is this fine?
  /// Deletes all data from this database.
  Future<void> deleteBusStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    await db.delete('busstops');
  }

  /// Replaces all of the data in this database with entries
  /// from [stops].
  Future<void> setBusStops(Map<String, BusStopData> stops) async {
    await deleteBusStops();
    await _insertBusStops(stops);
  }
}
