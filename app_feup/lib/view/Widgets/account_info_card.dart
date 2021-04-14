import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';

import 'generic_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class AccountInfoCard extends GenericCard {
  AccountInfoCard({Key key}) : super(key: key);

  AccountInfoCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(children: [
      Table(
          columnWidths: {1: FractionColumnWidth(.4)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Saldo: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
                child: StoreConnector<AppState, String>(
                    converter: (store) => store.state.content['feesBalance'],
                    builder: (context, feesBalance) =>
                        getInfoText(feesBalance, context)),
              )
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0),
                child: Text('Data limite próxima prestação: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeDelta: -4)),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 8.0, bottom: 20.0, right: 30.0),
                child: StoreConnector<AppState, String>(
                    converter: (store) => store.state.content['feesLimit'],
                    builder: (context, feesLimit) =>
                        getInfoText(feesLimit, context)),
              )
            ]),
          ]),
      StoreConnector<AppState, String>(
          converter: (store) => store.state.content['feesRefreshTime'],
          builder: (context, feesRefreshTime) =>
              this.showLastRefreshedTime(feesRefreshTime, context))
    ]);
  }

  @override
  String getTitle() => 'Conta Corrente';

  @override
  onClick(BuildContext context) {}
}
