import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../shared/constance.dart';

ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      color: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 20,
    )),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      elevation: 10,
    ));

ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: HexColor('#333333'),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('#333333'),
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    scaffoldBackgroundColor: HexColor('#333333'),
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 20,
    )),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: HexColor('#333333'),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey,
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      elevation: 10,
    ));
