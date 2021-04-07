import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';

/// Manages the app's Refresh Times database.
/// 
/// This database stores information about when certain data was updated
/// for the last time. 
class AppRefreshTimesDatabase extends AppDatabase {
  AppRefreshTimesDatabase()
      : super('refreshtimes.db',
            ['CREATE TABLE refreshtimes(event TEXT, time TEXT)']);

  /// Returns a map containing all the data stored in this database.
  /// 
  /// *Note:*
  /// * a key in this map is the type of data that was updated.
  /// * a value in this map is the time the corresponding last update occured.
  Future<Map<String, String>> refreshTimes() async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('refreshtimes');

    final Map<String, String> refreshTimes =  Map<String, String>();
    for (Map<String, dynamic> entry in maps) {
      if (entry['event'] == 'print') refreshTimes['print'] = entry['time'];
      if (entry['event'] == 'fees') refreshTimes['fees'] = entry['time'];
    }

    return refreshTimes;
  }

  // TODO Should this doc be more specific or is this fine?
  /// Deletes all of the data from this database.
  Future<void> deleteRefreshTimes() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('refreshtimes');
  }

  /// Updates the time stored for a given event.
  void saveRefreshTime(String event, String time) async {
    final Database db = await this.getDatabase();

    final List<Map> maps =
        await db.query('refreshtimes', where: 'event = ?', whereArgs: [event]);

    // New element
    if (maps.isEmpty) {
      await insertInDatabase('refreshtimes', {'event': event, 'time': time});
    }
    // Update element
    else {
      await db.update(
        'refreshtimes',
        {'time': time},
        where: 'event = ?',
        whereArgs: [event],
      );
    }
    // store date ou julian days ou smt else
  }
}
