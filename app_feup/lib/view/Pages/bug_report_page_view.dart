import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/bug_report_form.dart';

class BugReportPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BugReportPageViewState();
}

class BugReportPageViewState extends SecondaryPageViewState {

  @override
  Widget getBody(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: new BugReportForm()
    );
  }
}