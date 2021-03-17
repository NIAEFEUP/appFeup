/// Manages a generic Course.
///
/// This class stores all the information about a Course.
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

  /// Returns an instance of this Course from a json file.
  static Course fromJson(dynamic data) {
    return Course(
        id: data['cur_id'],
        festId: data['fest_id'],
        name: data['cur_nome'],
        currYear: data['ano_curricular'],
        firstEnrollment: data['fest_a_lect_1_insc']);
  }

  /// Converts a [Course] instance to map.
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
