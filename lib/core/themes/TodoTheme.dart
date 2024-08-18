import 'package:flutter/material.dart';

class TodoTheme {
  //light theme
  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade50,
      useMaterial3: false,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black, foregroundColor: Colors.white),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.black
  
      ),
      checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStatePropertyAll(Colors.white),
          overlayColor: MaterialStatePropertyAll(Colors.black),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.black))));

  //dark theme
  static final darkTheme = ThemeData(useMaterial3: false);
}
