import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Manages the app section displayed when the user presses the back button
class BackButtonExitWrapper extends StatelessWidget {
  BackButtonExitWrapper({
    Key key,
    @required this.context,
    @required this.child,
  }) : super(key: key);

  final BuildContext context;
  final Widget child;

  Future<bool> backButton() {
    return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Tens a certeza que pretendes sair?'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Não'),
                    ),
                    ElevatedButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop'),
                      child: Text('Sim'),
                    )
                  ],
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: this.child,
      onWillPop: () => this.backButton(),
    );
  }
}
