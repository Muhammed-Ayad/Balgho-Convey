import 'dart:async';

import 'package:great_quran/helpers/extensions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';

mixin BusSubscription {
  final Map<String, StreamSubscription> _subscriptions = {};

  @protected
  void on<T>(T event, EventBus eventBus, Function(T) handler) {
    _subscriptions.update(
      event.runtimeType.toString(),
      (oldSubscription) {
        // Cancel the old subscription
        oldSubscription.cancel();
        // Register and Add a new one
        return eventBus.on<T>().listen(handler);
      },
      ifAbsent: () => eventBus.on<T>().listen(handler),
    );
  }

  Future<void> _removeEventsListeners() async {
    _subscriptions.forEach((key, value) async {
      "Remove $key listener from [$runtimeType]".log();
      await value.cancel();
      _subscriptions.remove(key);
    });
  }

  @mustCallSuper
  dispose() async {
    "BusSubscription dispose in [$runtimeType] is called".log();
    await _removeEventsListeners();
  }
}
