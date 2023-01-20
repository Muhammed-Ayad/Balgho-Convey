import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/remote/apis/qibla_api.dart';
import '../../data/remote/interfaces/i_qibla_api.dart';
import '../state_mix/_index.dart';

class QiblaDirectionNotifier extends StateNotifier<GenericState<double>> {
  static final provider =
      StateNotifierProvider<QiblaDirectionNotifier, GenericState<double>>(
          (ref) {
    return QiblaDirectionNotifier(ref.read(QiblaApi.provider));
  });
  final IQiblaApi _api;
  QiblaDirectionNotifier(this._api) : super(GenericState.initial());

  Future<void> fetchQiblaDirection() async {
    try {
      state = GenericState.loading();
      final direction = await _api.getQiblaDirection();
      state = GenericState.success(direction);
    } catch (e, s) {
      state = GenericState.fail(e.toString());
      debugPrint('Qibla Notifier Error $e');
      debugPrint('Qibla Notifier Error Stack $s');
    }
  }
}
