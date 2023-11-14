import 'package:flutter/material.dart';

import '../calendar/color_pallet.dart';
import 'appTheme.dart';

final appThemeData = {
  AppTheme.StandardTheme: ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorPallet.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: ColorPallet.darkTextColor,
    fontFamily: 'Akko Pro',
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      hourMinuteShape: const CircleBorder(),
    ),
    primaryTextTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorPallet.darkTextColor),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: ColorPallet.midGray),
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorPallet.midGray).copyWith(background: Colors.white),
  ),
  AppTheme.AwesomeTheme: ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorPallet.midblue,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Akko Pro',
    primaryTextTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorPallet.darkTextColor),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: ColorPallet.midGray),
    ),
  ),
};
