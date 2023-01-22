import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../blocs/events/bus.dart';

extension WidgetRefEx on WidgetRef {
  //* Riverpod Event Extensions
  /// This function is usd as a `workaround` if you want to fire an `event` and make sure the listeners is created.
  /// to listen properly for your incoming event.
  void fire(Object event, {List<ProviderBase>? listeners}) {
    if (listeners != null) {
      for (final provider in listeners) {
        read(provider);
      }
    }
    read(Bus.provider).fire(event);
  }
}

extension ContextEx on BuildContext {
// Widgets Extensions
  void showAlertDialog(Widget widget) =>
      showDialog(context: this, builder: (context) => widget);

  // MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  //* Dimensions Extensions
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double heightR(double value) => mediaQuery.size.height * value;
  double widthR(double value) => mediaQuery.size.width * value;

  double webWidth(double web, {double? other}) =>
      isLargeWeb ? widthR(web) : widthR(other ?? 1);

  double webHeight(double web, {double? other}) =>
      kIsWeb ? heightR(web) : heightR(other ?? 1);

  // Device Breakpoints
  bool get isWideScreen => width >= 750;
  bool get isLargeWeb => isWideScreen && kIsWeb;

  bool get isLargeHeight => height > 800;
  bool get isSmallHeight => height < 530;

  // Accessibility
  bool get isScreenReaderActive => mediaQuery.accessibleNavigation;

  // Locale Extensions
  bool get isRTL =>
      intl.Bidi.isRtlLanguage(Localizations.localeOf(this).languageCode);

  // Theme Extensions
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Request UnFocus
  void unFocusRequest() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }
}

extension ListEx<T> on List<T> {
  bool update({required T oldItem, required T newItem}) {
    final index = indexOf(oldItem);
    if (index >= 0) {
      this[index] = newItem;
      return true;
    }
    return false;
  }
}

extension MapEx<K, V> on Map<K, V> {
  K keyAt(int index) => keys.elementAt(index);
  V valueAt(int index) => values.elementAt(index);
}
