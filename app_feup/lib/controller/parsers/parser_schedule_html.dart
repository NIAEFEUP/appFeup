import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:uni/model/entities/lecture.dart';

/// Returns a sorted list of exams from an HTTP response.
/// 
/// This function parses the webpage html and returns a list of exams
Future<List<Lecture>> getScheduleFromHtml(http.Response response) async {
  final document = parse(response.body);
  var semana = [0, 0, 0, 0, 0, 0];

  final List<Lecture> lecturesList = [];
  document.querySelectorAll('.horario > tbody > tr').forEach((Element element) {
    if (element.getElementsByClassName('horas').isNotEmpty) {
      var day = 0;
      final List<Element> children = element.children;
      for (var i = 1; i < children.length; i++) {
        for (var d = day; d < semana.length; d++) {
          if (semana[d] == 0) {
            break;
          }
          day++;
        }
        final clsName = children[i].className;
        if (clsName == 'TE' || clsName == 'TP' || clsName == 'PL') {
          final String subject =
              children[i].querySelector('b > acronym > a').text;
          String classNumber = null;

          if (clsName == 'TP' || clsName == 'PL') {
            classNumber = children[i].querySelector('span > a').text;
          }

          final Element rowSmall =
              children[i].querySelector('table > tbody > tr');
          final String room = rowSmall.querySelector('td > a').text;
          final String teacher = rowSmall.querySelector('td.textod a').text;

          final String typeClass = clsName;
          final int blocks = int.parse(children[i].attributes['rowspan']);
          final String startTime = children[0].text.substring(0, 5);

          semana[day] += blocks;

          final Lecture lect = Lecture.fromHtml(subject, typeClass, day,
              startTime, blocks, room, teacher, classNumber);
          lecturesList.add(lect);
        }
        day++;
      }
      semana = semana.expand((i) => [(i - 1) < 0 ? 0 : i - 1]).toList();
    }
  });
  lecturesList.sort((a, b) => a.compare(b));

  return lecturesList;
}
