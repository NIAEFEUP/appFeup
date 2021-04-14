import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';

/// Manages the section with the estimated time for the bus arrival
class EstimatedArrivalTimeStamp extends StatelessWidget {
  final String timeRemaining;

  EstimatedArrivalTimeStamp({
    Key key,
    @required this.timeRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DateTime>(
      converter: (store) => store.state.content['timeStamp'],
      builder: (context, timeStamp) {
        return this.getContent(context, timeStamp);
      },
    );
  }

  Widget getContent(BuildContext context, DateTime timeStamp) {
    final DateTime estimatedTime =
        timeStamp.add(Duration(minutes: int.parse(timeRemaining), seconds: 30));

    int num = estimatedTime.hour;
    final String hour = (num >= 10 ? '$num' : '0$num');
    num = estimatedTime.minute;
    final String minute = (num >= 10 ? '$num' : '0$num');

    return Text('$hour:$minute', style: Theme.of(context).textTheme.headline4);
  }
}
