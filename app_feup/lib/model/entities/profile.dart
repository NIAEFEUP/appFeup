import 'dart:convert';

import 'package:tuple/tuple.dart';

import 'course.dart';

/// Manages a generic User Profile.
///
/// This class stores all the information about a User Profile.
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

  ///Returns an instance of [Profile] a json document.
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

  /// Returns a list of tuples with two elements.
  ///
  /// *Example:*
  /// [('name':user1.Name), ('email':user1.email)]
  /// For more info read the class [Profile].
  List<Tuple2<String, String>> keymapValues() {
    return [
      Tuple2('name', this.name),
      Tuple2('email', this.email)
    ];
  }
}
