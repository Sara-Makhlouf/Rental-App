import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
  ),
);
