/// Stores information about a course.
class Course {
  final int id;
  final int festId;
  final String name;
  final String abbreviation;
  final String currYear;
  final int firstEnrollment;
  final String state;

  Course(
      {int this.id,
      int this.festId,
      String this.name,
      String this.abbreviation,
      String this.currYear,
      int this.firstEnrollment,
      String this.state = ''});

  /// Creates a new instance from a JSON object.
  static Course fromJson(dynamic data) {
    return Course(
        id: data['cur_id'],
        festId: data['fest_id'],
        name: data['cur_nome'],
        currYear: data['ano_curricular'],
        firstEnrollment: data['fest_a_lect_1_insc']);
  }

  /// Converts this course to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fest_id': festId,
      'name': name,
      'abbreviation': abbreviation,
      'currYear': currYear,
      'firstEnrollment': firstEnrollment,
      'state': state
    };
  }
}
