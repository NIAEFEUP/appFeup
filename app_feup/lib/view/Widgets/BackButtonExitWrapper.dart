import 'package:flutter/material.dart';


class BackButtonExitWrapper extends StatelessWidget{
  BackButtonExitWrapper({
    Key key,
    @required this.context,
    @required this.child,
    }):super(key: key);

  final BuildContext context;
  final Widget child;


  Future<bool> backButton(){
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Tem a certeza que pretende sair?'),
          actions: <Widget>[
            new RaisedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Não'),
                color: Theme.of(context).primaryColor,
            ),
            new RaisedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Sim'),
                color: Theme.of(context).primaryColor,

            )
          ],
        )
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: this.child,
        onWillPop: () => this.backButton(),
    );
  }
}