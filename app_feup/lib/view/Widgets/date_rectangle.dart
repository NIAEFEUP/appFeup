import 'package:flutter/material.dart';

/// Manages the sections of the app which display the current date.
///
/// Example: The rectangular section with the text "last update at [time]".
class DateRectangle extends StatelessWidget {

  final String date;

  DateRectangle({
    Key key,
    @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.only(bottom: 10),
      child: Text( date ,
          style: Theme.of(context).textTheme.subtitle2),
      alignment: Alignment.center,
      width: double.infinity,
    );
  }
}
