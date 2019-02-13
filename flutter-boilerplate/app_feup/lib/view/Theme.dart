import 'package:flutter/material.dart';


const Color primaryColor = Color.fromARGB(255, 0x8C, 0x2D, 0x19);
const Color accentColor = Color.fromARGB(255, 235, 235, 235);


ThemeData applicationTheme = new ThemeData(

  brightness: Brightness.light,
  primaryColor: primaryColor,
  accentColor: accentColor,

  fontFamily: 'Montserrat',

  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: primaryColor),
    title: TextStyle(fontSize: 36.0, color: accentColor),
    body1: TextStyle(fontSize: 18.0, color: primaryColor),
  ),
);