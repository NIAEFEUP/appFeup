import 'dart:async';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:app_feup/model/entities/Bus.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:sqflite/sqflite.dart';
import "package:collection/collection.dart";

class AppBusStopDatabase extends AppDatabase{

  AppBusStopDatabase():super('busstops.db', 'CREATE TABLE busstops(stopCode TEXT, busCode TEXT)');

  Future<List<BusStop>> busStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for all bus stops
    final List<Map<String, dynamic>> buses = await db.query('busstops');
    if(buses.length == 0)
      return new List();

    final List<BusStop> stops = new List();
    groupBy(buses, (stop)=>stop['stopCode']).forEach((stopCode,busCodeList) => stops.add(BusStop(stopCode, busCodeList.map((busEntry)=>Bus(busCode: busEntry['busCode'])).toList())));
    return stops;
  }

  Future<void> addBusStop(BusStop newStop) async {
    final List<BusStop> stops = await busStops();
    stops.add(newStop);
    print("Adding " + newStop.stopCode);
    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> removeBusStop(BusStop removedStop) async {
    final List<BusStop> stops = await busStops();
    print("Removing " + removedStop.stopCode);
    for (int i = 0; i < stops.length; i++) {
      if(stops[i].stopCode == removedStop.stopCode)
        stops.remove(stops[i]);
    }
    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> _insertBusStops(List<BusStop> stops) async {
    for (BusStop stop in stops) {
      for (Bus bus in stop.buses) {
        await insertInDatabase(
          'busstops',
          {'stopCode': stop.stopCode,
            'busCode': bus.busCode
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<void> _deleteBusStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    await db.delete('busstops');
  }
}