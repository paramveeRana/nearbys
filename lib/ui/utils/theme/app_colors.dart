import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool isDarkMode = false;

  static const Color primary = Color(0xff000000);
  static const Color primaryDAEBFF = Color(0xffDAEBFF);
  static const Color black838383 = Color(0xff838383);
  static const Color clrF0F5FF = Color(0xffF0F5FF);
  static const Color clr009AF1 = Color(0xff009AF1);
  static const Color clr2C4DA8 = Color(0xff2C4DA8);
  static const Color clrF5F8FF = Color(0xffF5F8FF);
  static const Color clrFFFFFF = Color(0xffFFFFFF);
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);
  // static const Color scaffoldBG = Color(0xff30343C);
  // static const Color scaffoldBG = Color(0xff1D1F23);
  static const Color scaffoldBG = Color(0xff3c404b);
  static const Color textSecondary = Color(0xff4C4C4C);
  static const Color textPrimary = Color(0xff000000);
  /// APP COLORS
  static MaterialColor colorPrimary = MaterialColor(0xffFEC34D, colorSwathes);

  static Map<int, Color> colorSwathes = {
    50: const Color.fromRGBO(31, 30, 31, .1),
    100: const Color.fromRGBO(31, 30, 31, .2),
    200: const Color.fromRGBO(31, 30, 31, .3),
    300: const Color.fromRGBO(31, 30, 31, .4),
    400: const Color.fromRGBO(31, 30, 31, .5),
    500: const Color.fromRGBO(31, 30, 31, .6),
    600: const Color.fromRGBO(31, 30, 31, .7),
    700: const Color.fromRGBO(31, 30, 31, .8),
    800: const Color.fromRGBO(31, 30, 31, .9),
    900: const Color.fromRGBO(31, 30, 31, .1),
  };

  static Color textByTheme() => isDarkMode ? white : primary;

  static Color textMainFontByTheme() => isDarkMode ? white : textPrimary;

  static Color scaffoldBGByTheme() => isDarkMode ? black : scaffoldBG;

  static Color textWhiteByNewBlack2() => isDarkMode ? white : black;

  // static Color textByTheme() => isDarkMode ? white : primary;

  // Body Parameter Chart Colors
  static const Color clr1E1E1E = Color(0xFF1E1E1E);
  static const Color clrGrey9E9E9E = Color(0xFF9E9E9E);

  static const Color clr26000000 = Color(0x26000000);
}
