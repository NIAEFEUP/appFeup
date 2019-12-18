import 'package:app_feup/view/Widgets/DateRectangle.dart';
import 'package:app_feup/view/Widgets/GenericCard.dart';
import 'package:app_feup/view/Widgets/RowContainer.dart';
import 'package:flutter/cupertino.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'ScheduleRow.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ExamCard extends GenericCard{


  ExamCard({Key key}):super(key: key);

  ExamCard.fromEditingInformation(Key key, bool editingMode, Function onDelete):super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => "Exames";

  @override
  onClick(BuildContext context) => Navigator.pushNamed(context, '/Mapa de Exames');

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['exams'],
      builder: (context, exams) =>
          super.getCardContentBasedOnRequestStatus(
              context,
              StoreProvider.of<AppState>(context).state.content['examsStatus'],
              generateExams,
              exams,
              exams != null && exams.length > 0)
    );
  }

  Widget generateExams(exams, context){
    return exams.length >= 1 ?
    new Column(
      mainAxisSize: MainAxisSize.min,
      children: this.getExamRows(context, exams),
    )
        : Center(
      child: Text("No exams to show at the moment", style: Theme.of(context).textTheme.display1),
    );
  }

  List<Widget> getExamRows(context, exams){
    List<Widget> rows = new List<Widget>();
    for(int i = 0; i < 1 && i < exams.length; i++){
      rows.add(this.createRowFromExam(context, exams[i]));
    }
    if(exams.length > 1){
      rows.add(
        new Container(
          margin: EdgeInsets.only(right: 80.0, left: 80.0, top: 15, bottom: 7),
          decoration: new BoxDecoration(
            border: new Border(bottom: BorderSide(width: 1.5, color: Theme.of(context).accentColor))
          ),
        )
      );
    }
    for(int i = 1; i < 4 && i < exams.length; i++){
      rows.add(this.createSecondaryRowFromExam(context, exams[i]));
    }
    return rows;
  }

  Widget createRowFromExam(context, exam){
    return new Column(children: [
                new DateRectangle(date: exam.weekDay + ", " + exam.day + " de " + exam.month),
                new Container(
                    child: RowContainer(
                      child: ScheduleRow(
                          subject: exam.subject,
                          rooms: exam.rooms,
                          begin: exam.begin,
                          end: exam.end
                      ),
                    )
                ),

    ]
    );
  }

  Widget createSecondaryRowFromExam(context, exam) {
    return new Container(
      margin: EdgeInsets.only(top: 8),
      child: new RowContainer(
        child: new Container(
          padding: EdgeInsets.all(11),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                  exam.day + "/" + exam.month,
                  style: Theme.of(context).textTheme.display1,
              ),
              new Text(
                  exam.subject,
                  style: Theme.of(context).textTheme.display2.apply(fontSizeDelta: 5)
              )
            ],
        ),
      ),
      ),
    );
  }
}
