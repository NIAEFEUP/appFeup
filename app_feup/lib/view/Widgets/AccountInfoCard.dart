import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/view/Theme.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'GenericCard.dart';

class AccountInfoCard extends GenericCard {

  AccountInfoCard({Key key}):super(key: key);

  AccountInfoCard.fromEditingInformation(Key key, bool editingMode, Function onDelete):super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
        return Column(children: [ Table(
            columnWidths: {1: FractionColumnWidth(.4)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, bottom: 8.0, left: 20.0),
                  child: Text("Saldo: ",
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, bottom: 8.0, right: 30.0),
                      child: StoreConnector<AppState, String>(
                        converter: (store) => store.state.content["feesBalance"],
                        builder: (context, feesBalance) => getInfoText(feesBalance, context)
                  ),
                )
              ]),
              TableRow(children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 8.0, bottom: 20.0, left: 20.0),
                  child: Text("Data limite próxima prestação: ",
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 8.0, bottom: 20.0, right: 30.0),
                      child: StoreConnector<AppState, String>(
                        converter: (store) => store.state.content["feesLimit"],
                        builder: (context, feesLimit) => getInfoText(feesLimit, context)
                      ),
                 )
              ]),
            ]
        ),
        StoreConnector<AppState, String>(
          converter: (store) => store.state.content["feesRefreshTime"],
          builder: (context, feesRefreshTime) => this.showLastRefreshedTime(feesRefreshTime, context)
        )]
        );
  }

  @override
  String getTitle() => "Conta Corrente";

  @override
  onClick(BuildContext context) {}

}