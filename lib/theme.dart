import 'package:flutter/material.dart';

ThemeData createTheme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(255, 233, 0, 1),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
