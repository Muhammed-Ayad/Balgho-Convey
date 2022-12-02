import 'package:flutter/material.dart';

mixin AppTheme {
  static ThemeData themeFactory() {
    // ThemeData
    return ThemeData(
      // <------------------------------------------------ Main Theme Font
      fontFamily: null,
      // <------------------------------------------ Color Scheme
      // colorScheme: const ColorScheme(),

      // <------------------------------------------------ Icon Theme
      iconTheme: const IconThemeData(),

      // <------------------------------------------------ Tab Bar Theme
      tabBarTheme: const TabBarTheme(),

      // <------------------------------------------------ App Bar Theme Theme
      appBarTheme: const AppBarTheme(),

      // <------------------------------------------------ Input Decoration Theme
      inputDecorationTheme: const InputDecorationTheme(),

      // <------------------------------------------------ Text Theme
      textTheme: const TextTheme(),

      // <--------------------------------------- Bottomsheet Theme
      bottomSheetTheme: const BottomSheetThemeData(),
    );
  }
}
