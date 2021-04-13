import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/redux/reducers.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Pages/about_page_view.dart';
import 'package:uni/view/Pages/bug_report_page_view.dart';
import 'package:uni/view/Pages/bus_stop_next_arrivals_page.dart';
import 'package:uni/view/Pages/exams_page_view.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Pages/logout_route.dart';
import 'package:uni/view/Pages/splash_page_view.dart';
import 'package:uni/view/Widgets/page_transition.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:uni/view/theme.dart';

import 'controller/on_start_up.dart';
import 'model/schedule_page_model.dart';

/// Stores the state of the app
final Store<AppState> state = Store<AppState>(appReducers,
    /* Function defined in the reducers file */
    initialState: AppState(null),
    middleware: [generalMiddleware]);

void main() {
  OnStartUp.onStart(state);
  runApp(MyApp());
}

/// Manages the state of the app
/// 
/// This class is necessary to track the app's state for
/// the current execution
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(
        state: Store<AppState>(appReducers,
            /* Function defined in the reducers file */
            initialState: AppState(null),
            middleware: [generalMiddleware]));
  }
}

/// Manages the app depending on its current state
class MyAppState extends State<MyApp> {
  MyAppState({@required this.state}) {}

  final Store<AppState> state;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StoreProvider(
      store: state,
      child: MaterialApp(
          title: 'uni',
          theme: applicationLightTheme,
          home: SplashScreen(),
          navigatorKey: NavigationService.navigatorKey,
          // ignore: missing_return
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/' + Constants.navPersonalArea:
                return PageTransition.makePageTransition(
                    page: HomePageView(), settings: settings);
              case '/' + Constants.navSchedule:
                return PageTransition.makePageTransition(
                    page: SchedulePage(), settings: settings);
              case '/' + Constants.navExams:
                return PageTransition.makePageTransition(
                    page: ExamsPageView(), settings: settings);
              case '/' + Constants.navStops:
                return PageTransition.makePageTransition(
                    page: BusStopNextArrivalsPage(), settings: settings);
              case '/' + Constants.navAbout:
                return PageTransition.makePageTransition(
                    page: AboutPageView(), settings: settings);
              case '/' + Constants.navBugReport:
                return PageTransition.makePageTransition(
                    page: BugReportPageView(),
                    settings: settings,
                    maintainState: false);
              case '/' + Constants.navLogOut:
                return LogoutRoute.buildLogoutRoute();
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 60),
        (Timer t) => state.dispatch(SetCurrentTimeAction(DateTime.now())));
  }
}
