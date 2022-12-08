import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';

import '../mix_extensions.dart';

mixin BusSubscription {
  final Map<String, StreamSubscription> _subscriptions = {};

  EventBus get eventBus;

  /// Must be called on the Notifier build() method to be activated.
  @protected
  void on<E>(E event, Function(E) handler) {
    _subscriptions.update(
      event.runtimeType.toString(),
      (oldSubscription) {
        // Cancel the old subscription
        oldSubscription.cancel();
        // Register and Add a new one
        return eventBus.on<E>().listen(handler);
      },
      ifAbsent: () => eventBus.on<E>().listen(handler),
    );
  }

  Future<void> _removeEventsListeners() async {
    _subscriptions.forEach((key, value) async {
      "Remove $key listener from [$runtimeType]".log();
      await value.cancel();
      _subscriptions.remove(key);
    });
  }

  /// Must be called in  ref.onDispose  callback or dispose method
  void disposeBusSubscriptions() async {
    "BusSubscription dispose in [$runtimeType] is called".log();
    await _removeEventsListeners();
  }
}
