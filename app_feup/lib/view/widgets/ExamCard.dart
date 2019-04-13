import 'package:app_feup/view/widgets/GenericCard.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'ExamRow.dart';
import 'SecondaryExamRow.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ExamCard extends StatelessWidget{

  final double padding = 4.0;

  ExamCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['exams'],
      builder: (context, exams){
        return GenericCard(
            title: "Exames",
            func: () => Navigator.pushReplacementNamed(context, '/Mapa de Exames'),
            child:
                exams.length >= 1 ?
                Container(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: this.getExamRows(context, exams),
                    ))
                : Center(
                  child: Text("No exams to show at the moment"),
                ));
      },
    );
  }

  List<Widget> getExamRows(context, exams){
    List<Widget> rows = new List<Widget>();
    int i = 0;
    for(; i < 2 && i < exams.length; i++){
      rows.add(this.createRowFromExam(context, exams[i]));
    }
    for(; i < 5 && i < exams.length; i++){
      rows.add(this.createSecondaryRowFromExam(context, exams[i]));
    }
    return rows;
  }

  Widget createRowFromExam(context, exam){
    return new ExamRow(
          subject: exam.subject,
          rooms: exam.rooms,
          begin: exam.begin,
          day: exam.day,
          month: exam.month,
      );
  }

  Widget createSecondaryRowFromExam(context, exam){
    return new SecondaryExamRow(
          subject: exam.subject,
          rooms: exam.rooms,
          begin: exam.begin,
          day: exam.day,
          month: exam.month,
      );
  }
}
