import 'dart:async';
import 'package:uni/model/entities/course.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

/// Manages the app's Courses database.
/// 
/// This database stores information about the user's courses.
/// See the [Course] class to see what data is stored in this database.
class AppCoursesDatabase extends AppDatabase {
  AppCoursesDatabase()
      : super('courses.db', [
          '''CREATE TABLE courses(id INTEGER, fest_id INTEGER, name TEXT,
          abbreviation TEXT, currYear TEXT, firstEnrollment INTEGER, state TEXT)'''
        ]);

  /// Replaces all of the data in this database with [courses].
  saveNewCourses(List<Course> courses) async {
    await deleteCourses();
    await _insertCourses(courses);
  }

  /// Returns a list containing all of the courses stored in this database.
  Future<List<Course>> courses() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Courses.
    final List<Map<String, dynamic>> maps = await db.query('courses');

    // Convert the List<Map<String, dynamic> into a List<Course>.
    return List.generate(maps.length, (i) {
      return Course(
          id: maps[i]['id'],
          festId: maps[i]['fest_id'],
          name: maps[i]['name'],
          abbreviation: maps[i]['abbreviation'],
          currYear: maps[i]['currYear'],
          firstEnrollment: maps[i]['firstEnrollment'],
          state: maps[i]['state']);
    });
  }

  /// Adds all items from [courses] to this database.
  /// 
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertCourses(List<Course> courses) async {
    for (Course course in courses) {
      await insertInDatabase(
        'courses',
        course.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteCourses() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('courses');
  }

  // TODO Is this okay?
  /// Updates the state of all courses present in [states].
  /// 
  /// *Note:*
  /// * a key in [states] should be a [Course.id].
  /// * a value in [states] should be the new state of the corresponding course.
  void saveCoursesStates(Map<String, String> states) async {
    final Database db = await this.getDatabase();

    // Retrieve stored courses
    final List<Course> courses = await this.courses();

    // For each course, save its state
    for (Course course in courses) {
      await db.update(
        'courses',
        {'state': states[course.name]},
        where: 'id = ?',
        whereArgs: [course.id],
      );
    }
  }
}
