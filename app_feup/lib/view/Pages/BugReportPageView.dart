import 'package:app_feup/view/Pages/SecondaryPageView.dart';
import 'package:app_feup/view/Widgets/BugReportForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BugReportPageView extends SecondaryPageView {

  @override
  Widget getBody(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: new BugReportForm()
    );
  }
}