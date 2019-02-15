import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/Pages/LoginPageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:redux/redux.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();

  //Handle arguments from parent
  LoginPage({Key key}) : super(key: key);
}

class _LoginPageState extends State<LoginPage> {
  
  FocusNode usernameFocus;
  FocusNode passwordFocus;

  TextEditingController usernameController;
  TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    usernameFocus.dispose();
    passwordFocus.dispose();

    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new LoginPageView(
        checkboxValue: _keepSignedIn,
        setCheckboxValue: _setKeepSignedIn,
        usernameFocus: usernameFocus,
        passwordFocus: passwordFocus,
        usernameController: usernameController,
        passwordController: passwordController,
        submitForm: () => _login(StoreProvider.of<AppState>(context)));
  }

  //check this boolean to save or not the username and password on the mobile
  bool _keepSignedIn = false;
  
  void _setKeepSignedIn(value){
    setState(() {
      _keepSignedIn = value;
    });
  }

  void _login(Store<AppState> store) {
    final user = usernameController.text;
    final pass = passwordController.text;
    print(user);
    print(pass);
    store.dispatch(login(user, pass, _keepSignedIn));
  }
}
