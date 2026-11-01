import 'package:flutter/material.dart';
import 'package:great_quran/core/theme/font_manager.dart';

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

  static TextStyle getRegularStyle(
      {double fontSize = FontSizeManager.s12, required Color color}) {
    return _getTextStyle(fontSize, FontWeightManager.regular, color);
  }

  static TextStyle getMediumStyle(
      {double fontSize = FontSizeManager.s12, required Color color}) {
    return _getTextStyle(fontSize, FontWeightManager.medium, color);
  }

  static TextStyle getSemiBoldStyle(
      {double fontSize = FontSizeManager.s12, required Color color}) {
    return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
  }

  static TextStyle getBoldStyle(
      {double fontSize = FontSizeManager.s12, required Color color}) {
    return _getTextStyle(fontSize, FontWeightManager.bold, color);
  }
}
