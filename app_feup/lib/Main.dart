import 'package:app_feup/model/SchedulePageModel.dart';
import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/view/NavigationService.dart';
import 'package:app_feup/view/Pages/ClassificationsPageView.dart';
import 'package:app_feup/view/Pages/ExamsPageView.dart';
import 'package:app_feup/view/Pages/HomePageView.dart';
import 'package:app_feup/view/Pages/MapPageView.dart';
import 'package:app_feup/view/Pages/MenuPageView.dart';
import 'package:app_feup/view/Pages/ParkPageView.dart';
import 'package:app_feup/view/Pages/AboutPageView.dart';
import 'package:app_feup/controller/Middleware.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/view/Pages/SplashPageView.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'controller/OnStartUp.dart';
import 'model/LoginPageModel.dart';
import 'view/Theme.dart';
import 'model/AppState.dart';
import 'package:redux/redux.dart';
import 'redux/Reducers.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/controller/LifecycleEventHandler.dart';

final Store<AppState> state = Store<AppState>(
    appReducers, /* Function defined in the reducers file */
    initialState: new AppState(null),
    middleware: [generalMiddleware]
);

void main() {
  OnStartUp.onStart(state);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp> {

  WidgetsBindingObserver lifeCycleEventHandler;

  @override
  Widget build(BuildContext context) {
   SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
   return StoreProvider(
    store: state,
    child: MaterialApp(
        title: 'App FEUP',
        theme: applicationTheme,
        home: SplashScreen(),
        navigatorKey: NavigationService.navigatorKey,
        routes: {
            '/Área Pessoal': (context) {
              StoreProvider.of<AppState>(context).dispatch(updateSelectedPage("Área Pessoal"));
              return HomePageView();
            },
            '/Horário': (context) {
              StoreProvider.of<AppState>(context).dispatch(updateSelectedPage("Horário"));
              return SchedulePage();
            },
            '/Classificações': (context) {
              StoreProvider.of<AppState>(context).dispatch(updateSelectedPage("Classificações"));
              return ClassificationsPageView();
            },
            '/Ementa': (context) {
              StoreProvider.of<AppState>(context).dispatch(updateSelectedPage("Ementa"));
              return MenuPageView();
            },
            '/Mapa de Exames': (context) {
              StoreProvider.of<AppState>(context).dispatch(updateSelectedPage("Mapa de Exames"));
              return ExamsPageView();
            },
            '/Parques': (context) {
              StoreProvider.of<AppState>(context).dispatch(updateSelectedPage("Parques"));
              return ParkPageView();
            },
            '/Mapa FEUP': (context) {
              StoreProvider.of<AppState>(context).dispatch(updateSelectedPage("Mapa FEUP"));
              return MapPageView();
            },
            '/About': (context) {
              StoreProvider.of<AppState>(context).dispatch(updateSelectedPage("About"));
              return AboutPageView();
            },
            '/Login': (context) {
              return LoginPage();
            }
        },
    )
  );}

  @override
  void initState() {
    super.initState();
    this.lifeCycleEventHandler = new LifecycleEventHandler(store: state);
    WidgetsBinding.instance.addObserver(this.lifeCycleEventHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this.lifeCycleEventHandler);
    super.dispose();
  }
}


