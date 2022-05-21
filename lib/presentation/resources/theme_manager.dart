import 'package:flutter/material.dart';
import 'font_manager.dart';
import 'styles_manager.dart';
import 'values_manager.dart';

import 'color_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    //*  main Colors
    primaryColor: ColorManager.white,
    primaryColorLight: ColorManager.white,
    primaryColorDark: ColorManager.white,
    disabledColor: ColorManager.white,
    splashColor: ColorManager.white,

    //*  Card View theme

    cardTheme: CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4,
    ),

    //*  button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: ColorManager.grey1,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.white,
    ),
    //* elevation Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
            color: ColorManager.white, fontSize: FontSizeManager.s12),
        primary: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),
    //*  text theme
    textTheme: TextTheme(
      displayMedium: getMediumStyle(
          color: ColorManager.darkGrey, fontSize: FontSizeManager.s22),
      displayLarge: getSemiBoldStyle(
          color: ColorManager.darkGrey, fontSize: FontSizeManager.s22),
      headlineSmall: getSemiBoldStyle(
          color: ColorManager.darkGrey, fontSize: FontSizeManager.s18),
      //* appBarTitle
      headlineMedium: getMediumStyle(
          color: ColorManager.darkGrey, fontSize: FontSizeManager.s20),
      //* bag title
      headlineLarge: getSemiBoldStyle(
          color: ColorManager.darkGrey, fontSize: FontSizeManager.s22),
      //* smoll text
      titleSmall: getRegularStyle(
          color: ColorManager.darkGrey, fontSize: FontSizeManager.s18),
      titleMedium: getMediumStyle(
          color: ColorManager.darkGrey, fontSize: FontSizeManager.s20),
      titleLarge: getSemiBoldStyle(
          color: ColorManager.primary, fontSize: FontSizeManager.s22),
      //* bag text
      bodySmall: getRegularStyle(color: ColorManager.grey),
      bodyMedium: getMediumStyle(color: ColorManager.grey),
      bodyLarge: getSemiBoldStyle(
          color: ColorManager.grey1, fontSize: FontSizeManager.s14),
    ),
  );
}
