// Copyright (c) 2023 by Salama Enigma (salama92work@gmail.com)
// All rights reserved.
// Check out my Github account (https://github.com/salamaEnigma) for more projects.

// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer' as devtools;

extension LogEx on Object? {
  void log({bool isError = false, String tag = "Enigma"}) =>
      devtools.log(toString(),
          error: this is Exception || isError ? "Error" : null, name: tag);
}

extension Unwrap<T> on Future<T?> {
  Future<T> unwrap() => then(
        (value) => value != null ? Future<T>.value(value) : Future.any([]),
      );
}

extension StreamUtils<T> on Stream<T> {
  Stream<T> whereTypeNot<S>() {
    return where((event) => event is! S);
  }
}
