import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../mix_extensions.dart';

/// Supported RxDart Subjects types
enum RxSubjectType { behavior, replay }

// * ---------------------------------------------------------- * //

/// Adds Rx Subjects supports on Notifiers
mixin RxSubject<S> on Notifier<S> {
  BehaviorSubject<S>? _behaviorSubject;
  ReplaySubject<S>? _replaySubject;

  RxSubjectType? _rxSubjectType;

  /// Must be called on the Notifier build() method to be activated.
  @protected
  void registerRxSubject(RxSubjectType rxSubjectType) {
    if (_rxSubjectType == null) {
      _rxSubjectType = rxSubjectType;
      switch (rxSubjectType) {
        case RxSubjectType.behavior:
          _behaviorSubject ??= BehaviorSubject();
          ref.listenSelf(
            (_, next) {
              _behaviorSubject!.sink.add(next);
            },
          );
          break;
        case RxSubjectType.replay:
          _replaySubject ??= ReplaySubject();
          ref.listenSelf(
            (_, next) {
              _replaySubject!.sink.add(next);
            },
          );
          break;
        default:
          return;
      }
    }
  }

  Stream<S>? get rxState {
    switch (_rxSubjectType) {
      case RxSubjectType.behavior:
        _behaviorSubject ??= BehaviorSubject();
        return _behaviorSubject!.stream;
      case RxSubjectType.replay:
        _replaySubject ??= ReplaySubject();
        return _replaySubject!.stream;
      default:
        return null;
    }
  }

  /// Must be called in ref.onDispose callback or dispose method.
  @protected
  disposeRxSubject() async {
    "RXState dispose in [$runtimeType] is called".log();
    _rxSubjectType = null;
    await _behaviorSubject?.close();
    await _replaySubject?.close();
  }
}

// * ---------------------------------------------------------- * //

/// Adds Rx Subjects supports on StateNotifiers
mixin RxForStateNotifier<S> on StateNotifier<S> {
  ReplaySubject<S>? _replaySubject;

  RxSubjectType? _rxSubjectType;

  /// Must be called on the StateNotifier constructor to be activated.
  @protected
  void registerRxSubject(RxSubjectType rxSubjectType) {
    if (_rxSubjectType == null) {
      _rxSubjectType = rxSubjectType;
      switch (rxSubjectType) {
        case RxSubjectType.replay:
          _replaySubject ??= ReplaySubject();
          _replaySubject!.addStream(behaviorStream);
          break;

        default:
          return;
      }
    }
  }

  Stream<S>? get rxState {
    switch (_rxSubjectType) {
      case RxSubjectType.behavior:
        return behaviorStream;
      case RxSubjectType.replay:
        _replaySubject ??= ReplaySubject();
        return _replaySubject!.stream;
      default:
        return null;
    }
  }

  /// Must be called in  ref.onDispose callback or dispose method
  @protected
  disposeRxSubject() async {
    "RXState dispose in [$runtimeType] is called".log();
    _rxSubjectType = null;
    await _replaySubject?.close();
  }
}
