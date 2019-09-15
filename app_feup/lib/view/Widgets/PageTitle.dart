import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PageTitle extends StatelessWidget {
  final String name;

  const PageTitle({
    Key key,
    @required this.name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
      alignment: Alignment.center,
      child: new Text(
        name,
        style: Theme.of(context).textTheme.title.apply(fontSizeDelta: 7, fontWeightDelta: -2),
      ),
    );
  }
}