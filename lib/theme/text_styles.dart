//* ##################### App TextStyles ######################

import 'package:flutter/material.dart';
import 'package:great_quran/theme/font_manager.dart';

mixin AppTextStyles {
  static TextStyle _getTextStyle(
      double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(
      fontFamily: FontFamilyNames.messiriFont,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

//* regular
  static TextStyle getRegularStyle(
      {double fontSize = FontSizeManager.s12, required Color color}) {
    return _getTextStyle(fontSize, FontWeightManager.regular, color);
  }

//* medium
  static TextStyle getMediumStyle(
      {double fontSize = FontSizeManager.s12, required Color color}) {
    return _getTextStyle(fontSize, FontWeightManager.medium, color);
  }

//* semiBold
  static TextStyle getSemiBoldStyle(
      {double fontSize = FontSizeManager.s12, required Color color}) {
    return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
  }

//* Bold
  static TextStyle getBoldStyle(
      {double fontSize = FontSizeManager.s12, required Color color}) {
    return _getTextStyle(fontSize, FontWeightManager.bold, color);
  }
}
