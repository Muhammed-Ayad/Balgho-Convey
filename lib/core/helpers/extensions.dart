import 'dart:developer' as devtools;
import 'package:flutter/material.dart';
import 'package:great_quran/l10n/app_localizations.dart';

extension LogEx on Object? {
  void log({bool isError = false, String tag = "Enigma"}) =>
      devtools.log(toString(),
          error: this is Exception || isError ? "Error" : null, name: tag);
}

extension ContextEx on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double heightR(double value) => mediaQuery.size.height * value;
  double widthR(double value) => mediaQuery.size.width * value;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
