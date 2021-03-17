import 'package:uni/model/entities/exam.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';

// TODO Should this doc be more descriptive or is this fine?
/// Manages the exam parsing
///
/// This class `ParserExams` contains methods to enable the user to parse
/// exams information 
class ParserExams {

  final types = {
    'Especial de Conclusão': 'EC',
    'Port.Est.Especiais': 'EE',
    'Mini-testes': 'MT',
    'Normal': 'EN',
    'Recurso': 'ER'
  };

  /// Returns the abbreviature of the exam season.
  ///
  /// If an abbreviature doesn't exist, an '?' is returned.
  String getExamSeasonAbbr(String seasonStr) {
    final Map<String, String> examTypes = Exam.getExamTypes();
    for (String type in examTypes.keys) {
      if (seasonStr.contains(type)) return examTypes[type];
    }
    return '?';
  }

  /// Extracts a list of exams from an HTTP response.
  Future<List<Exam>> parseExams(http.Response response) async {
    final document = parse(response.body);

    final List<Exam> examsList = [];
    final List<String> dates = [];
    final List<String> examTypes = [];
    final List<String> weekDays = [];
    String subject, schedule, rooms;
    int days = 0;
    int tableNum = 0;
    document.querySelectorAll('h3').forEach((Element examType) {
      examTypes.add(getExamSeasonAbbr(examType.text));
    });

    document
        .querySelectorAll('div > table > tbody > tr > td')
        .forEach((Element element) {
      element.querySelectorAll('table:not(.mapa)').forEach((Element table) {
        table.querySelectorAll('th').forEach((Element week) {
          weekDays.add(week.text.substring(0, week.text.indexOf('2')));
        });
        table.querySelectorAll('span.exame-data').forEach((Element date) {
          dates.add(date.text);
        });

        table.querySelectorAll('td.l.k').forEach((Element exams) {
          if (exams.querySelector('td.exame') != null) {
            exams.querySelectorAll('td.exame').forEach((Element examsDay) {
              if (examsDay.querySelector('a') != null) {
                subject = examsDay.querySelector('a').text;
              }
              if (examsDay.querySelector('span.exame-sala') != null) {
                rooms = examsDay.querySelector('span.exame-sala').text;
              }

              schedule = examsDay.text.substring(examsDay.text.indexOf(':') - 2,
                  examsDay.text.indexOf(':') + 9);
              final Exam exam = Exam(schedule, subject, rooms, dates[days],
                  examTypes[tableNum], weekDays[days]);
              examsList.add(exam);
            });
          }
          days++;
        });
      });
      tableNum++;
    });
    return examsList;
  }
}
