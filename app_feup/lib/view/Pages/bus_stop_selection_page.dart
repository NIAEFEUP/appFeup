import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/bus_stop_search.dart';
import 'package:uni/view/Widgets/bus_stop_selection_row.dart';
import 'package:uni/view/Widgets/page_title.dart';

class BusStopSelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BusStopSelectionPageState();
}

/// Manages the 'Bus stops' section of the app.
class BusStopSelectionPageState extends UnnamedPageView {
  final double borderRadius = 15.0;
  final DateTime now = DateTime.now();

  final db = AppBusStopDatabase();
  final Map<String, BusStopData> configuredStops = Map();
  final List<String> suggestionsList = [];

  List<Widget> getStopsTextList() {
    final List<Widget> stops = [];
    configuredStops.forEach((stopCode, stopData) {
      stops.add(Text(stopCode));
    });
    return stops;
  }

  @override
  Widget getBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StoreConnector<AppState, Map<String, BusStopData>>(
      converter: (store) => store.state.content['configuredBusStops'],
      builder: (context, busStops) {
        final List<Widget> rows = [];
        busStops.forEach((stopCode, stopData) =>
            rows.add(BusStopSelectionRow(stopCode, stopData)));

        return ListView(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            children: <Widget>[
              Container(child: PageTitle(name: 'Paragens Configuradas')),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                      '''As paragens favoritas serão apresentadas no widget \'Paragens\' dos favoritos. As restantes serão apresentadas apenas na página.''',
                      textAlign: TextAlign.center)),
              Column(children: rows),
              Container(
                  padding:
                      EdgeInsets.only(left: width * 0.20, right: width * 0.20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => showSearch(
                              context: context, delegate: BusStopSearch()),
                          child: Container(
                            child: Text('Adicionar'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Container(
                            child: Text('Concluído'),
                          ),
                        ),
                      ]))
            ]);
      },
    );
  }
}
