import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/view/Theme.dart';

import 'GenericCard.dart';

class PrintInfoCard extends GenericCard{
  PrintInfoCard({Key key, this.printBalance, this.printRefreshTime});

  final String printBalance, printRefreshTime;

  @override
  Widget buildCardContent(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Table(
            columnWidths: {1: FractionColumnWidth(.4)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
                  child: Text("Valor disponível: ",
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, right: 30.0),
                  child: getInfoText(printBalance, context),
                ),
              ])
            ]
        ),
        showLastRefreshedTime(printRefreshTime, context)
      ],
    );
  }

  @override
  String getTitle() => "Impressões";

  @override
  onClick(BuildContext context) {}

}