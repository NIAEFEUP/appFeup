import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/Pages/login_page_view.dart';
import 'package:uni/view/Widgets/terms_and_condition_dialog.dart';
import 'package:uni/view/theme.dart';

import 'home_page_view.dart';
import 'logout_route.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Manages the splash screen displayed after a successful login.
class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startTimeAndChangeRoute();
  }

  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration:
                BoxDecoration(color: applicationLightTheme.backgroundColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: queryData.size.height / 4)),
              createTitle(),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                      padding:
                          EdgeInsets.only(bottom: queryData.size.height / 16)),
                  createNILogo(),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: queryData.size.height / 6))
            ],
          )
        ],
      ),
    );
  }

  /// Creates the app Title container with the app's logo.
  Widget createTitle() {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: queryData.size.width / 8,
          minHeight: queryData.size.height / 6,
        ),
        child: SizedBox(
            child: SvgPicture.asset(
              'assets/images/logo_dark.svg',
              color: Theme.of(context).accentColor,
            ),
            width: 150.0));
  }

  /// Creates the app main logo
  Widget createNILogo() {
    return SvgPicture.asset(
      'assets/images/by_niaefeup.svg',
      color: Theme.of(context).accentColor,
      width: queryData.size.width * 0.45,
    );
  }

  // Redirects the user to the proper page depending on his login input.
  void startTimeAndChangeRoute() async {
    Route<Object> nextRoute;
    final Tuple2<String, String> userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    final String userName = userPersistentInfo.item1;
    final String password = userPersistentInfo.item2;
    if (userName != '' && password != '') {
      nextRoute = await getTermsAndConditions(userName, password);
    } else {
      await acceptTermsAndConditions();
      nextRoute = MaterialPageRoute(builder: (context) => LoginPageView());
    }
    Navigator.pushReplacement(context, nextRoute);
  }

  Future<MaterialPageRoute> getTermsAndConditions(
      String userName, String password) async {
    final completer = Completer<TermsAndConditionsState>();
    await TermsAndConditionDialog.build(context, completer, userName, password);
    final state = await completer.future;

    switch (state) {
      case TermsAndConditionsState.accepted:
        StoreProvider.of<AppState>(context)
            .dispatch(reLogin(userName, password, 'feup'));
        return MaterialPageRoute(builder: (context) => HomePageView());

      case TermsAndConditionsState.rejected:
        return LogoutRoute.buildLogoutRoute();
    }

    return Future.error(
        Exception('Unexpected terms and condition state: $state'));
  }
}
