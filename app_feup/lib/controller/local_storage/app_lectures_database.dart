import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:sqflite/sqflite.dart';

/// Manages the app's Lectures database.
/// 
/// This database stores information about the user's lectures.
/// See the [Lecture] class to see what data is stored in this database.
class AppLecturesDatabase extends AppDatabase {
  static final createScript =
      '''CREATE TABLE lectures(subject TEXT, typeClass TEXT,
          day INTEGER, startTime TEXT, blocks INTEGER, room TEXT, teacher TEXT, classNumber TEXT)''';
  static final updateClassNumber =
      '''ALTER TABLE lectures ADD classNumber TEXT''';

  AppLecturesDatabase()
      : super(
            'lectures.db',
            [
              createScript,
            ],
            onUpgrade: migrate,
            version: 3);

  /// Replaces all of the data in this database with [lecs].
  saveNewLectures(List<Lecture> lecs) async {
    await deleteLectures();
    await _insertLectures(lecs);
  }

  /// Returns a list containing all of the lectures stored in this database.
  Future<List<Lecture>> lectures() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('lectures');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Lecture.fromHtml(
        maps[i]['subject'],
        maps[i]['typeClass'],
        maps[i]['day'],
        maps[i]['startTime'],
        maps[i]['blocks'],
        maps[i]['room'],
        maps[i]['teacher'],
        maps[i]['classNumber'],
      );
    });
  }

  /// Adds all items from [lecs] to this database.
  /// 
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertLectures(List<Lecture> lecs) async {
    for (Lecture lec in lecs) {
      await this.insertInDatabase(
        'lectures',
        lec.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteLectures() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('lectures');
  }

  /// Migrates [db] from [oldVersion] to [newVersion].
  /// 
  /// *Note:* This operation only updates the schema of the tables present in
  /// the database and, as such, all data is lost.
  static FutureOr<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    if (oldVersion == 1) {
      batch.execute('DROP TABLE IF EXISTS lectures');
      batch.execute(createScript);
    } else if (oldVersion == 2) {
      batch.execute(updateClassNumber);
    }
    await batch.commit();
  }
}
