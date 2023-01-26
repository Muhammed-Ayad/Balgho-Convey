// Copyright (c) 2023 by Salama Enigma (salama92work@gmail.com)
// All rights reserved.
// Check out my Github account (https://github.com/salamaEnigma) for more projects.

import '../generic_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AsyncFetchFunction<T> = Future<T> Function();
mixin DataFetcher<T> on Notifier<GenericState<T>> {
  @protected
  AsyncFetchFunction<T> get dataFetcher;

  Future<void> fetchData({VoidCallback? onSuccess}) async {
    state = GenericState.loading();
    final result = await GenericState.guard(dataFetcher);
    state = result;
    if (result.isSuccess) {
      onSuccess?.call();
    }
  }
}

// * ---------------------------------------------------------- * //

mixin DataFetcherForStateNotifier<T> on StateNotifier<GenericState<T>> {
  @protected
  AsyncFetchFunction<T> get dataFetcher;

  Future<void> fetchData({VoidCallback? onSuccess}) async {
    state = GenericState.loading();
    final result = await GenericState.guard(dataFetcher);
    state = result;
    if (result.isSuccess) {
      onSuccess?.call();
    }
  }
}
