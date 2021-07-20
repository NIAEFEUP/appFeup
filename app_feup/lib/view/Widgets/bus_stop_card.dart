import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/bus_stop_selection_page.dart';
import 'package:uni/view/Widgets/bus_stop_row.dart';
import 'package:uni/view/Widgets/last_update_timestamp.dart';
import 'package:uni/view/Widgets/row_container.dart';

import 'generic_card.dart';

/// Manages the bus stops card displayed on the user's personal area
class BusStopCard extends GenericCard {
  BusStopCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => 'Paragens';

  @override
  onClick(BuildContext context) => Navigator.pushNamed(context, '/Paragens');

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<
            AppState,
            Tuple3<Map<String, List<Trip>>, Map<String, BusStopData>,
                RequestStatus>>(
        converter: (store) => Tuple3(
            store.state.content['currentBusTrips'],
            store.state.content['configuredBusStops'],
            store.state.content['busstopStatus']),
        builder: (context, trips) =>
            getCardContent(context, trips.item1, trips.item2, trips.item3));
  }

  /// Returns a widget with the bus stop card final content
  Widget getCardContent(BuildContext context, Map<String, List<Trip>> trips,
      Map<String, BusStopData> stopConfig, busStopStatus) {
    switch (busStopStatus) {
      case RequestStatus.successful:
        if (trips.isNotEmpty) {
          return Column(children: <Widget>[
            this.getCardTitle(context),
            this.getBusStopsInfo(context, trips, stopConfig)
          ]);
        } else {
          return Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Configura as tuas paragens',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .apply(color: Theme.of(context).accentColor)),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BusStopSelectionPage())),
                  )
                ]),
          );
        }
        break;
      case RequestStatus.busy:
        return Column(
          children: <Widget>[
            this.getCardTitle(context),
            Container(
                padding: EdgeInsets.all(22.0),
                child: Center(child: CircularProgressIndicator()))
          ],
        );
      case RequestStatus.failed:
      default:
        return Column(children: <Widget>[
          this.getCardTitle(context),
          Container(
              padding: EdgeInsets.all(8.0),
              child: Text('Não foi possível obter informação',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .apply(color: Theme.of(context).accentColor)))
        ]);
        break;
    }
  }

  /// Returns a widget for the title of the bus stops card
  Widget getCardTitle(context) {
    return Row(
      children: <Widget>[
        Icon(Icons.directions_bus), // color lightgrey
        Text('STCP - Próximas Viagens',
            style: Theme.of(context)
                .textTheme
                .headline4
                .apply(color: Theme.of(context).accentColor)),
      ],
    );
  }

  /// Returns a widget for all the bus stops info
  Widget getBusStopsInfo(context, trips, stopConfig) {
    if (trips.length >= 1) {
      return Container(
          padding: EdgeInsets.all(4.0),
          child: Column(
            children: this.getEachBusStopInfo(context, trips, stopConfig),
          ));
    } else {
      return Center(
        child: Text('Não há dados a mostrar neste momento',
            maxLines: 2, overflow: TextOverflow.fade),
      );
    }
  }

  /// Returns a list of widgets for each bus stop info that exists
  List<Widget> getEachBusStopInfo(context, trips, stopConfig) {
    final List<Widget> rows = <Widget>[];

    rows.add(LastUpdateTimeStamp());

    trips.forEach((stopCode, tripList) {
      if (tripList.length > 0 && stopConfig[stopCode].favorited) {
        rows.add(Container(
            padding: EdgeInsets.only(top: 12.0),
            child: RowContainer(
                child: BusStopRow(
              stopCode: stopCode,
              trips: tripList,
              singleTrip: true,
            ))));
      }
    });

    return rows;
  }
}
