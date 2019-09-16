import 'package:app_feup/controller/LoadInfo.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/Pages/ProfilePageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:io';

import 'entities/Course.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();

  //Handle arguments from parent
  ProfilePage({Key key}) : super(key: key);
}

class _ProfilePageState extends State<ProfilePage> {
  
  String name;
  String email;
  Map<String, String> currentState;
  List<Course> courses;
  Future<File> profilePicFile;

  @override
  void initState() {
    super.initState();
    name = "";
    email = "";
    currentState = {};
    courses = [];
    profilePicFile = null;

  }

  @override
  Widget build(BuildContext context) {
    profilePicFile = loadProfilePic( StoreProvider.of<AppState>(context));
    updateInfo();
    return FutureBuilder(future: profilePicFile,
    builder: (BuildContext context,
    AsyncSnapshot<File> profilePic){
      return new ProfilePageView(
          name: name,
          email: email,
          currentState: currentState,
          courses: courses, profilePicFile: profilePic.data);
    });

  }

  void updateInfo() async{
    setState(() {
      if(StoreProvider.of<AppState>(context).state.content['profile'] != null) {
        name = StoreProvider
            .of<AppState>(context)
            .state
            .content['profile'].name;
        email = StoreProvider
            .of<AppState>(context)
            .state
            .content['profile'].email;
        currentState = StoreProvider
            .of<AppState>(context)
            .state
            .content['coursesStates'];
        courses = StoreProvider
            .of<AppState>(context)
            .state
            .content['profile'].courses;
      }
    });
  }
}