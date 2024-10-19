import 'package:flutter/material.dart';
import 'package:money_maker/CUSTOM/custom_font.dart';
import 'package:money_maker/EXTENSION/color_extension.dart';

class PerfectTeme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: "#F0F8FF".toColor(),
    appBarTheme: const AppBarTheme(
      
      surfaceTintColor: Colors.transparent,
      
      elevation: 5,
      shadowColor: Colors.black12,
    
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    textTheme: TextTheme(
      displayLarge:
          PerfectTypogaphy.bold.copyWith(fontSize: 32, color: Colors.black87),
      displayMedium:
          PerfectTypogaphy.bold.copyWith(fontSize: 28, color: Colors.black87),
      bodyLarge: PerfectTypogaphy.regular
          .copyWith(fontSize: 16, color: Colors.black87),
      bodyMedium: PerfectTypogaphy.regular
          .copyWith(fontSize: 14, color: Colors.black87),
      bodySmall:
          PerfectTypogaphy.regular.copyWith(fontSize: 12, color: Colors.grey),
      labelLarge:
          PerfectTypogaphy.bold.copyWith(fontSize: 16, color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: "#eff3fc".toColor(),
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        selectedLabelStyle: PerfectTypogaphy.regular.copyWith(
          letterSpacing: 0.5,
          color: Colors.black87,
        )),
  );
}
