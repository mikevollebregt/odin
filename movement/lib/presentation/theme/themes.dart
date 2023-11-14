import 'package:flutter/material.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../color_pallet.dart';
import '../../infrastructure/repositories/dtos/enums/app_theme.dart';

final appThemeData = {
  AppTheme.StandardTheme: ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    primaryColor: ColorPallet.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: ColorPallet.darkTextColor,
    fontFamily: 'Akko Pro',
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      hourMinuteShape: const CircleBorder(),
    ),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(fontSize: 16 * f, fontWeight: FontWeight.w500, color: ColorPallet.darkTextColor),
      bodyText1: TextStyle(fontSize: 16 * f, fontWeight: FontWeight.normal, color: ColorPallet.midGray),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorPallet.midGray),
  ),
  AppTheme.AwesomeTheme: ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorPallet.midblue,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Akko Pro',
    primaryTextTheme: TextTheme(
      headline1: TextStyle(fontSize: 16 * f, fontWeight: FontWeight.w500, color: ColorPallet.darkTextColor),
      bodyText1: TextStyle(fontSize: 16 * f, fontWeight: FontWeight.normal, color: ColorPallet.midGray),
    ),
  ),
};
