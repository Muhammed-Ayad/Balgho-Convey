import 'dart:async';

import 'package:great_quran/blocs/states/generic_state.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part '../states/splash_state.dart';

/// A StateNotifier provider that is responsible of displaying splash screen  with loading while the
/// app is loading necessary initial data.
class SplashNotifier extends StateNotifier<GenericState<InitComplete>> {
  static final provider =
      StateNotifierProvider<SplashNotifier, GenericState<InitComplete>>(
          (ref) => SplashNotifier(ref),
          name: "Splash Provider");

  // ignore: unused_field
  final StateNotifierProviderRef _ref;

  //* Constructor and Methods
  SplashNotifier(
    this._ref,
  ) : super(
          GenericState.initial(),
        );

  /// Starts app splash loading to load all essentials data.
  /// changes it to [InitComplete].
  Future<void> init({
    required int splashTimeInSeconds,
  }) async {
    state = GenericState.loading();

    // Start stopwatch to calculate all process elapsed times
    final stopwatch = Stopwatch()..start();

    try {
      /// ***  Here We Put All Async Initialization Operations ***
    } catch (e, s) {
      "Error in app initialization\n$e".log(isError: true);
      "Error stack \n$s".log();
      state = GenericState.fail("Error starting the app");
    }

    stopwatch.elapsed.log(tag: "Splash Loading Time");
    // Complete Initialization with the elapsed time
    state = GenericState.success(
      InitComplete(
          initDuration: stopwatch.elapsed,
          splashScreenTime: splashTimeInSeconds),
    );

    stopwatch.stop();
  }
}
