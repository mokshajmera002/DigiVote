// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class mytheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: Colors.white,
      canvasColor: creme,
      // ignore: deprecated_member_use
      buttonColor: darkbluish,
      accentColor: darkbluish,
      indicatorColor: Colors.black,
      appBarTheme: AppBarTheme(
          color: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: Theme.of(context).textTheme));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: Colors.black,
      canvasColor: darkcreme,
      indicatorColor: Colors.white,
      // ignore: deprecated_member_use
      buttonColor: lightkbluish,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
          color: Colors.black,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: Theme.of(context).textTheme));

  //Colors
  static Color creme = Color(0xfff5f5f5);
  static Color darkcreme = Vx.gray900;
  static Color darkbluish = Color(0xff403b58);
  static Color lightkbluish = Vx.indigo400;
  static Color prim = Color(0xFF31cbaf);
}
