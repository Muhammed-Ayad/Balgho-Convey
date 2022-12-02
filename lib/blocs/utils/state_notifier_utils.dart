// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

extension HotUtils<T> on StateNotifier<T> {
  Stream<T> get hotStream {
    return stream.startWith(state);
  }

  Future<S> awaitState<S extends T>({
    bool Function(S)? predicate,
    bool eager = true,
  }) {
    predicate ??= (_) => true;
    final stream = eager ? hotStream : this.stream;
    return stream.whereType<S>().where(predicate).first;
  }

  Future<T> awaitStateNot<S extends T>({
    bool Function(T)? predicate,
    bool eager = true,
  }) {
    predicate ??= (_) => true;
    final stream = eager ? hotStream : this.stream;
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

extension StreamUtils<T> on Stream<T> {
  Stream<T> whereTypeNot<S>() {
    return where((event) => event is! S);
  }
}
