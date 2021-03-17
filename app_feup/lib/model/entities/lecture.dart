import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

/// Manages a generic Lecture.
///
/// This class stores all the information about a Lecture.
class Lecture {
  static var dayName = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo'
  ];
  String subject;
  String startTime;
  String endTime;
  String typeClass;
  String room;
  String teacher;
  String classNumber;
  int day;
  int blocks;
  int startTimeSeconds;

  /// Creates an instance of the class [Lecture].
  Lecture(
      String subject,
      String typeClass,
      int day,
      int blocks,
      String room,
      String teacher,
      String classNumber,
      int startTimeHours,
      int startTimeMinutes,
      int endTimeHours,
      int endTimeMinutes) {
    this.subject = subject;
    this.typeClass = typeClass;
    this.room = room;
    this.teacher = teacher;
    this.day = day;
    this.blocks = blocks;
    this.classNumber = classNumber;
    this.startTime = startTimeHours.toString().padLeft(2, '0') +
        'h' +
        startTimeMinutes.toString().padLeft(2, '0');
    this.endTime = endTimeHours.toString().padLeft(2, '0') +
        'h' +
        endTimeMinutes.toString().padLeft(2, '0');
  }

  factory Lecture.fromApi(
      String subject,
      String typeClass,
      int day,
      int startTimeSeconds,
      int blocks,
      String room,
      String teacher,
      String classNumber) {
    final startTimeHours = (startTimeSeconds ~/ 3600);
    final startTimeMinutes = ((startTimeSeconds % 3600) ~/ 60);
    final endTimeSeconds = 60 * 30 * blocks;
    final endTimeHours = (endTimeSeconds ~/ 3600);
    final endTimeMinutes = ((endTimeSeconds % 3600) ~/ 60);
    final lecture = Lecture(
        subject,
        typeClass,
        day,
        blocks,
        room,
        teacher,
        classNumber,
        startTimeHours,
        startTimeMinutes,
        endTimeHours,
        endTimeMinutes);
    lecture.startTimeSeconds = startTimeSeconds;
    return lecture;
  }

  factory Lecture.fromHtml(
      String subject,
      String typeClass,
      int day,
      String startTime,
      int blocks,
      String room,
      String teacher,
      String classNumber) {
    final startTimeHours = int.parse(startTime.substring(0, 2));
    final startTimeMinutes = int.parse(startTime.substring(3, 5));
    final endTimeHours =
        (startTimeMinutes + (blocks * 30)) ~/ 60 + startTimeHours;
    final endTimeMinutes = (startTimeMinutes + (blocks * 30)) % 60;
    return Lecture(subject, typeClass, day, blocks, room, teacher, classNumber,
        startTimeHours, startTimeMinutes, endTimeHours, endTimeMinutes);
  }

  /// Clones an instance of [Lecture].
  static Lecture clone(Lecture lec) {
    return Lecture.fromApi(
        lec.subject,
        lec.typeClass,
        lec.day,
        lec.startTimeSeconds,
        lec.blocks,
        lec.room,
        lec.teacher,
        lec.classNumber);
  }

  /// Clones an instance of [Lecture].
  static Lecture cloneHtml(Lecture lec) {
    return Lecture.fromHtml(lec.subject, lec.typeClass, lec.day, lec.startTime,
        lec.blocks, lec.room, lec.teacher, lec.classNumber);
  }

  /// Converts a [Lecture] instance to map.
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'typeClass': typeClass,
      'day': day,
      'startTime': startTime,
      'blocks': blocks,
      'room': room,
      'teacher': teacher,
      'classNumber': classNumber,
    };
  }

  /// Displays an instance of [Lecture] to the user.
  printLecture() {
    Logger().i(subject + ' ' + typeClass);
    Logger().i(dayName[day] +
        ' ' +
        startTime +
        ' ' +
        endTime +
        ' ' +
        blocks.toString() +
        ' blocos');
    Logger().i(room + '  ' + teacher + '\n');
  }

  /// Compares the times of two different instances of [Lecture].
  /// 
  /// If the lectures are going to happen in the same day, compares the start
  /// times. If they aren't compares the days.
  int compare(Lecture other) {
    if (day == other.day) {
      return startTime.compareTo(other.startTime);
    } else {
      return day.compareTo(other.day);
    }
  }

  @override
  int get hashCode => hashValues(subject, startTime, endTime, typeClass, room,
      teacher, day, blocks, startTimeSeconds);

  @override
  bool operator ==(o) =>
      o is Lecture &&
      this.subject == o.subject &&
      this.startTime == o.startTime &&
      this.endTime == o.endTime &&
      this.typeClass == o.typeClass &&
      this.room == o.room &&
      this.teacher == o.teacher &&
      this.day == o.day &&
      this.blocks == o.blocks &&
      this.startTimeSeconds == o.startTimeSeconds;
}
