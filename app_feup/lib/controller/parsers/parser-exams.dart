import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';

var months = {
'Janeiro' : '01',
'Fevereiro' : '02',
'Março' : '03',
'Abril' : '04',
'Maio' : '05',
'Junho' : '06',
'Julho' : '07',
'Agosto' : '08',
'Setembro' : '09',
'Outubro' : '10',
'Novembro' : '11',
'Dezembro' : '12'
};

class Exam{
  String subject;
  String begin;
  String end;
  String rooms;
  String day;
  String examType;
  String weekDay;
  String month;
  String year;
  DateTime date;



  Exam.secConstructor(String subject, String begin, String end, String rooms, String day, String examType, String weekDay, String month, String year){
    this.subject = subject;
    this.begin = begin;
    this.end = end;
    this.rooms = rooms;
    this.day = day;
    this.examType = examType;
    this.weekDay = weekDay;
    this.month = month;
    this.year = year;

    var monthKey = months[this.month];
    this.date = DateTime.parse(year + '-'  + monthKey + '-' + day);
  }

  Exam(String schedule, String subject, String rooms, String date, String examType, String weekDay)
  {
    this.subject = subject;
    this.date = DateTime.parse(date);
    var scheduling = schedule.split('-');
    var dateSepared = date.split('-');
    this.begin = scheduling[0].replaceAll(':', 'h');
    this.end = scheduling[1].replaceAll(':', 'h');
    this.rooms = rooms;
    this.year = dateSepared[0];
    this.day = dateSepared[2];
    this.examType = examType;
    this.weekDay = weekDay;

    this.month = months.keys.firstWhere(
            (k) => months[k] == dateSepared[1], orElse: () => null);
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'begin': begin,
      'end': end,
      'rooms': rooms,
      'day': day,
      'examType': examType,
      'weekDay': weekDay,
      'month': month,
      'year': year
    };
  }

  void printExam()
  {
    print('$subject - $year - $month - $day -  $begin-$end - $examType - $rooms - $weekDay');
  }
}

Future<List<Exam>> examsGet(String link) async{

  var response = await http.get(link);

  var document = await parse(response.body);

  List<Exam> Exams = new List();
  List<String> dates = new List();
  List<String> examTypes = new List();
  List<String> weekDays = new List();
  String subject, schedule, rooms;
  int days = 0;
  int tableNum = 0;
  document.querySelectorAll('h3').forEach((Element examType){
    examTypes.add(examType.text);
  });
  
  document.querySelectorAll('div > table > tbody > tr > td').forEach((Element element){
    element.querySelectorAll('table:not(.mapa)').forEach((Element table) {
      table.querySelectorAll('th').forEach((Element week){
        weekDays.add(week.text.substring(0, week.text.indexOf('2')));
      });
      table.querySelectorAll('span.exame-data').forEach((Element date) {
        dates.add(date.text);
      });

      table.querySelectorAll('td.l.k').forEach((Element exams) {
        if(exams.querySelector('td.exame') != null)
        {
          exams.querySelectorAll('td.exame').forEach((Element examsDay) {
          if(examsDay.querySelector('a') != null)
          {
            subject = examsDay.querySelector('a').text;
          }
          if(examsDay.querySelector('span.exame-sala') != null) 
          {
            rooms = examsDay.querySelector('span.exame-sala').text;
          }

          schedule = examsDay.text.substring(examsDay.text.indexOf(':') -2, examsDay.text.indexOf(':') + 9);
          Exam exam = new Exam(schedule, subject, rooms, dates[days], examTypes[tableNum], weekDays[days]);
          Exams.add(exam);
          });
        }
          days++;
      });
    });
    tableNum++;
  });
  return Exams;
}

