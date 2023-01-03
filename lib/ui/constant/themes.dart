import 'package:app/gen/fonts.gen.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:flutter/material.dart';

bool isDarkTheme(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

final lightTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: primaryColor,
  primarySwatch: primaryCustomSwatch,
  brightness: Brightness.light,
  fontFamily: FontFamily.nunitoSans,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
  ).apply(
    bodyColor: blackColor,
    displayColor: blackColor,
  ),
  colorScheme: const ColorScheme.light()
      .copyWith(primary: primaryColor, onPrimary: primaryColor)
      .copyWith(
          primary: primaryColor,
          secondary: primaryColor,
          brightness: Brightness.light),
  textSelectionTheme: TextSelectionThemeData(cursorColor: primaryColor),
);

final darkTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: blackGrayColor,
  primarySwatch: primaryCustomSwatchDark,
  backgroundColor: blackBGColor,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white,
  ),
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
  ).apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  fontFamily: FontFamily.nunitoSans,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
  scaffoldBackgroundColor: blackBGColor,
  colorScheme: const ColorScheme.dark()
      .copyWith(primary: blackGrayColor, onPrimary: blackGrayColor)
      .copyWith(
        secondary: blackGrayColor,
        brightness: Brightness.dark,
      ),
  textSelectionTheme: TextSelectionThemeData(cursorColor: blackGrayColor),
);
