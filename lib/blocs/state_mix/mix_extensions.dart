// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools;

import 'event_bus.dart';

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

extension RxUtils<T> on StateNotifier<T> {
  Stream<T> get behaviorStream {
    return stream.startWith(state);
  }

  Future<S> awaitState<S extends T>({
    bool Function(S)? predicate,
    bool eager = true,
  }) {
    predicate ??= (_) => true;
    final stream = eager ? behaviorStream : this.stream;
    return stream.whereType<S>().where(predicate).first;
  }

  Future<T> awaitStateNot<S extends T>({
    bool Function(T)? predicate,
    bool eager = true,
  }) {
    predicate ??= (_) => true;
    final stream = eager ? behaviorStream : this.stream;
    return stream.whereTypeNot<S>().where(predicate).first;
  }

  void wireTo(StateNotifier<T> other, {bool fireImmediately = true}) {
    other.addListener(
      (state) {
        this.state = state;
      },
      fireImmediately: fireImmediately,
    );
  }
}
