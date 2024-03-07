import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 147,74,156),
  primaryColorLight: const Color.fromARGB(255, 236, 164, 199),
  primaryColorDark: const Color(0xff513C80),
  canvasColor: const Color(0xfffafafa),
  scaffoldBackgroundColor: const Color(0xfff5f3f3),
  secondaryHeaderColor: const Color(0xfffdf4e7),
  dialogBackgroundColor: const Color(0xffffffff),
  indicatorColor: const Color.fromARGB(255, 147,74,156),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 147,74,156),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      backgroundColor: const Color.fromARGB(255, 147, 74, 156),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  ),
);