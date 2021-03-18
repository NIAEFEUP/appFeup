/// Stores information about a course unit.
class CourseUnit {
  int id;
  String code;
  String abbreviation;
  String name;
  int curricularYear;
  int occurrId;
  String semesterCode;
  String semesterName;
  String type;
  String status;
  String grade;
  String ectsGrade;
  String result;
  num ects;

  CourseUnit({this.id,
  this.code,
  this.abbreviation,
  this.name,
  this.curricularYear,
  this.occurrId,
  this.semesterCode,
  this.semesterName,
  this.type,
  this.status,
  this.grade,
  this.ectsGrade,
  this.result,
  this.ects});

  /// Creates a new instance from a JSON object.
  static CourseUnit fromJson(dynamic data) {
    return CourseUnit(
      id: data['ucurr_id'],
      code: data['ucurr_codigo'],
      abbreviation: data['ucurr_sigla'],
      name: data['ucurr_nome'],
      curricularYear: data['ano'],
      occurrId: data['ocorr_id'],
      semesterCode: data['per_codigo'],
      semesterName: data['per_nome'],
      type: data['tipo'],
      status: data['estado'],
      grade: data['resultado_melhor'],
      ectsGrade: data['resultado_ects'],
      result: data['resultado_insc'],
      ects: data['creditos_ects']
    );
  }

}