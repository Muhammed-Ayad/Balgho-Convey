import 'package:intl/intl.dart';

/// A collection of simple algorithms to reduce code boilerplate.
mixin Utilities {
  static String dateTimeNow() => DateFormat('yyyy-MM-dd').format(DateTime.now());
}
