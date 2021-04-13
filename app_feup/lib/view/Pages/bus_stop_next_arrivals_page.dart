import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/bus_stop_selection_page.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/bus_stop_row.dart';
import 'package:uni/view/Widgets/last_update_timestamp.dart';
import 'package:uni/view/Widgets/page_title.dart';

class BusStopNextArrivalsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BusStopNextArrivalsPageState();
}

/// Manages the 'Bus arrivals' section inside the user's personal area
class BusStopNextArrivalsPageState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<
            AppState,
            Tuple3<Map<String, List<Trip>>, Map<String, BusStopData>,
                RequestStatus>>(
        converter: (store) => Tuple3(
            store.state.content['currentBusTrips'],
            store.state.content['configuredBusStops'],
            store.state.content['busstopStatus']),
        builder: (context, busstops) {
          return ListView(children: [
            NextArrivals(busstops.item1, busstops.item2, busstops.item3)
          ]);
        });
  }
}

class NextArrivals extends StatefulWidget {
  final Map<String, List<Trip>> trips;
  final Map<String, BusStopData> busConfig;
  final RequestStatus busStopStatus;

  NextArrivals(this.trips, this.busConfig, this.busStopStatus);

  @override
  _NextArrivalsState createState() =>
      _NextArrivalsState(trips, busConfig, busStopStatus);
}

/// Manages the 'Bus arrivals' section inside the user's personal area
class _NextArrivalsState extends State<NextArrivals>
    with SingleTickerProviderStateMixin {
  final Map<String, List<Trip>> trips;
  final Map<String, BusStopData> busConfig;
  final RequestStatus busStopStatus;
  TabController tabController;

  _NextArrivalsState(this.trips, this.busConfig, this.busStopStatus);

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: busConfig.length);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (busStopStatus) {
      case RequestStatus.successful:
        return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(children: this.requestSuccessful(context)));
        break;
      case RequestStatus.busy:
        return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(children: this.requestBusy(context)));
        break;
      case RequestStatus.failed:
        return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(children: this.requestFailed(context)));
        break;
      default:
        return Container();
        break;
    }
  }

  /// Returns a list of widgets for a successfull request
  List<Widget> requestSuccessful(context) {
    final List<Widget> result = <Widget>[];

    result.addAll(this.getHeader(context));

    if (busConfig.isNotEmpty) {
      result.addAll(this.getContent(context));
    } else {
      result.add(Container(
          child: Text('Não se encontram configuradas paragens',
              style: Theme.of(context).textTheme.headline4)));
    }

    return result;
  }

  /// TODO: Is this ok?
  /// Returns a list of widgets for a busy request
  List<Widget> requestBusy(BuildContext context) {
    final List<Widget> result = <Widget>[];

    result.add(getPageTitle());
    result.add(Container(
        padding: EdgeInsets.all(22.0),
        child: Center(child: CircularProgressIndicator())));

    return result;
  }

  Container getPageTitle() {
    return Container(
        padding: EdgeInsets.only(bottom: 12.0),
        child: PageTitle(name: 'Paragens'));
  }

  /// Returns a list of widgets for a failed request
  List<Widget> requestFailed(BuildContext context) {
    final List<Widget> result = <Widget>[];

    result.addAll(this.getHeader(context));
    result.add(Container(
        padding: EdgeInsets.only(bottom: 12.0),
        child: Text('Não foi possível obter informação',
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.bodyText1)));

    return result;
  }

  List<Widget> getHeader(context) {
    return [
      getPageTitle(),
      Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10.0),
                child: LastUpdateTimeStamp(),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).accentColor,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusStopSelectionPage())))
            ]),
      )
    ];
  }

  List<Widget> getContent(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return [
      Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0),
          ),
        ),
        constraints: BoxConstraints(maxHeight: 150.0),
        child: Material(
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: createTabs(queryData),
          ),
        ),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.only(bottom: 92.0),
          child: TabBarView(
            controller: tabController,
            children: getEachBusStopInfo(context),
          ),
        ),
      )
    ];
  }

  List<Widget> createTabs(queryData) {
    final List<Widget> tabs = <Widget>[];
    busConfig.forEach((stopCode, stopData) {
      tabs.add(Container(
        width: queryData.size.width /
            (busConfig.length < 3 ? busConfig.length : 3),
        child: Tab(text: stopCode),
      ));
    });
    return tabs;
  }

  /// Returns a list of widgets, for each bus stop configured by the user
  List<Widget> getEachBusStopInfo(context) {
    final List<Widget> rows = <Widget>[];

    busConfig.forEach((stopCode, stopData) {
      rows.add(ListView(children: <Widget>[
        Container(
            padding:
                EdgeInsets.only(top: 8.0, bottom: 8.0, left: 22.0, right: 22.0),
            child: BusStopRow(
              stopCode: stopCode,
              trips: trips[stopCode],
              stopCodeShow: false,
            ))
      ]));
    });

    return rows;
  }
}
