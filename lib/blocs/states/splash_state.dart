part of '../notifiers/splash_notifier.dart';

/// A class that represent app splash loading completes with [Duration] `initDuration` to show how long it took it to initialize the app.
class InitComplete {
  final Duration initDuration;
  final int splashScreenTime;

  Duration get durationToWait => Duration(
      seconds: initDuration.inSeconds >= splashScreenTime
          ? 0
          : splashScreenTime - initDuration.inSeconds);

  InitComplete({required this.initDuration, required this.splashScreenTime});
}
