import '../generic_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin DataFetcher<T> on Notifier<GenericState<T>> {
  @protected
  Future<T> Function() get dataFetcher;

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
  Future<T> Function() get dataFetcher;

  Future<void> fetchData({VoidCallback? onSuccess}) async {
    state = GenericState.loading();
    final result = await GenericState.guard(dataFetcher);
    state = result;
    if (result.isSuccess) {
      onSuccess?.call();
    }
  }
}
