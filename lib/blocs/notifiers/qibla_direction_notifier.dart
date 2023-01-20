import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/remote/apis/qibla_api.dart';
import '../../data/remote/interfaces/i_qibla_api.dart';
import '../state_mix/_index.dart';

class QiblaDirectionNotifier extends StateNotifier<GenericState<double>>
    with DataFetcherForStateNotifier {
  static final provider =
      StateNotifierProvider<QiblaDirectionNotifier, GenericState<double>>(
          (ref) {
    return QiblaDirectionNotifier(ref.read(QiblaApi.provider));
  });
  final IQiblaApi _api;
  QiblaDirectionNotifier(this._api) : super(GenericState.initial());

  @override
  AsyncFetchFunction<double> get dataFetcher => () => _api.getQiblaDirection();
}
