import 'package:uni/view/Theme.dart';
import 'package:tuple/tuple.dart';

import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LastUpdateTimeStamp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Tuple2<DateTime, DateTime>>(
      converter: (store) => Tuple2(store.state.content['timeStamp'], store.state.content['currentTime']),
      builder: (context, timeStamps){
        return new Container(
          padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
          child: this.getContent(context, timeStamps)
        );
      },
    );
  }

  Widget getContent(BuildContext context, timeStamps) {
    Duration last_update = timeStamps.item2.difference(timeStamps.item1);
    int last_update_minutes = last_update.inMinutes;

    return new Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children : [
          Text('Atualizado há $last_update_minutes minuto' + (last_update_minutes != 1? 's' : ''),style: Theme.of(context).textTheme.display1.apply(color: greyTextColor))
        ]
    );
  }
}