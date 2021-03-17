import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:collection';

/// Returns a map containing the name of the course
/// and the year of the first enrollment.
///
/// *Note:*
/// * a key in this map is the name of the course `course`.
/// * a value in this map is the year of enrollment `state`.
Future<Map<String, String>> parseCourses(http.Response response) async {
  final document = parse(response.body);

  final Map<String, String> coursesStates =  HashMap();

  final courses =
      document.querySelectorAll('.estudantes-caixa-lista-cursos > div');

  for (int i = 0; i < courses.length; i++) {
    final div = courses[i];
    final course = div.querySelector('.estudante-lista-curso-nome > a').text;
    final state = div.querySelectorAll('.formulario td')[3].text;

    coursesStates.putIfAbsent(course, () => state);
  }

  return coursesStates;
}
