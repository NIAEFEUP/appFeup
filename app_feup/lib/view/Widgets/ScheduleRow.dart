import 'package:flutter/material.dart';
import 'ScheduleTimeInterval.dart';
import 'ScheduleEventRectangle.dart';


class ScheduleRow extends StatelessWidget{
  final String subject;
  final List<String> rooms;
  final String begin;
  final String end;
  final String teacher;
  final String type;

  ScheduleRow({
    Key key,
    @required this.subject,
    @required this.rooms,
    @required this.begin,
    @required this.end,
    this.teacher,
    this.type
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          padding: EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
          margin: EdgeInsets.only(top: 8.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new ScheduleTimeInterval(begin: this.begin, end: this.end),
              new ScheduleEventRectangle(subject: this.subject, type: this.type),
              new Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: getScheduleRooms(context)
                )
              )
            ],
          ),
        )
    );
  }

  List<Widget> getScheduleRooms(context){
    List<Widget> rooms = new List();
    for(String room in this.rooms){
      rooms.add(
        new Text(
          room,
          style: Theme.of(context).textTheme.display1.apply(fontSizeDelta: -4),
        ),
      );
    }
    return rooms;
  }
}