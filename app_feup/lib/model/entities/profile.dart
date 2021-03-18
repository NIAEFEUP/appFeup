import 'dart:convert';

import 'package:tuple/tuple.dart';

import 'course.dart';

/// Stores information about the user's profile.
class Profile {
  final String name;
  final String email;
  List<Course> courses;
  final String printBalance;
  final String feesBalance;
  final String feesLimit;

  Profile({
    this.name = '',
    this.email = '',
    this.courses,
    this.printBalance = '',
    this.feesBalance = '',
    this.feesLimit = ''});

  /// Creates a new instance from a JSON object.
  static Profile fromResponse(dynamic response) {
    final responseBody = json.decode(response.body);
    final List<Course> courses = <Course>[];
    for (var c in responseBody['cursos']) {
      courses.add(Course.fromJson(c));
    }
    return Profile(
        name: responseBody['nome'],
        email: responseBody['email'],
        courses: courses);
  }

  /// Returns a list with two tuples: the first tuple contains the user's name
  /// and the other one contains the user's email.
  List<Tuple2<String, String>> keymapValues() {
    return [
      Tuple2('name', this.name),
      Tuple2('email', this.email)
    ];
  }
}
