import 'package:logger/logger.dart';

var months = {
  'Janeiro': '01',
  'Fevereiro': '02',
  'Março': '03',
  'Abril': '04',
  'Maio': '05',
  'Junho': '06',
  'Julho': '07',
  'Agosto': '08',
  'Setembro': '09',
  'Outubro': '10',
  'Novembro': '11',
  'Dezembro': '12'
};

var _types = {
  'Mini-testes': 'MT',
  'Normal': 'EN',
  'Recurso': 'ER',
  'Especial de Conclusão': 'EC',
  'Port.Est.Especiais': 'EE',
  'Exames ao abrigo de estatutos especiais': 'EAE'
};

/// Manages a generic Exam.
///
/// This class stores all the information about an Exam.
class Exam {
  String subject;
  String begin;
  String end;
  List<String> rooms;
  String day;
  String examType;
  String weekDay;
  String month;
  String year;
  DateTime date;

  /// Constructs an instance of the class [Exam].
  Exam.secConstructor(String subject, String begin, String end, String rooms,
      String day, String examType, String weekDay, String month, String year) {
    this.subject = subject;
    this.begin = begin;
    this.end = end;
    this.rooms = rooms.split(',');
    this.day = day;
    this.examType = examType;
    this.weekDay = weekDay;
    this.month = month;
    this.year = year;

    final monthKey = months[this.month];
    this.date = DateTime.parse(year + '-' + monthKey + '-' + day);
  }

  /// Creates an instance of the class [Exam].
  Exam(String schedule, String subject, String rooms, String date,
      String examType, String weekDay) {
    this.subject = subject;
    this.date = DateTime.parse(date);
    final scheduling = schedule.split('-');
    final dateSepared = date.split('-');
    this.begin = scheduling[0];
    this.end = scheduling[1];
    this.rooms = rooms.split(',');
    this.year = dateSepared[0];
    this.day = dateSepared[2];
    this.examType = examType;
    this.weekDay = weekDay;

    this.month = months.keys
        .firstWhere((k) => months[k] == dateSepared[1], orElse: () => null);
  }

  /// Converts a [Exam] instance to map.
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'begin': begin,
      'end': end,
      'rooms': rooms.join(','),
      'day': day,
      'examType': examType,
      'weekDay': weekDay,
      'month': month,
      'year': year
    };
  }

  /// Returns a bool to sign if the Exam time has already passed.
  /// 
  /// This function returns `true` if the exam has already ended
  /// and `false` if it has not.  
  bool hasEnded() {
    final DateTime now = DateTime.now();
    final int endHour = int.parse(end.split(':')[0]);
    final int endMinute = int.parse(end.split(':')[1]);
    final DateTime endDateTime =
        DateTime(date.year, date.month, date.day, endHour, endMinute);
    return now.compareTo(endDateTime) <= 0;
  }

  void printExam() {
    Logger().i(
        '''$subject - $year - $month - $day -  $begin-$end - $examType - $rooms - $weekDay''');
  }

  @override
  String toString() {
    return '''$subject - $year - $month - $day -  $begin-$end - $examType - $rooms - $weekDay''';
  }

  static Map<String, String> getExamTypes() {
    return _types;
  }

  static getExamTypeLong(String abr) {
    final Map<String, String> reversed = _types.map((k, v) => MapEntry(v, k));
    return reversed[abr];
  }
}
