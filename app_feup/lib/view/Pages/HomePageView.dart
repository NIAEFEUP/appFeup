import 'package:app_feup/view/Widgets/ScheduleCard.dart';
import 'package:app_feup/view/Widgets/HomePageBackButton.dart';
import 'package:flutter/material.dart';
import '../Widgets/ExamCard.dart';
import '../Pages/GeneralPageView.dart';

class HomePageView extends GeneralPageView {

  @override
  Widget getBody(BuildContext context) {
    return new HomePageBackButton(
        context: context,
        child:  new ListView(
          shrinkWrap: false,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: new Text(
                'Favorites:',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            ExamCard(),

            ScheduleCard(),
          ],
        ),
    );
  }
}
