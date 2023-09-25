import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/state_mix/fetch_data_mixins.dart';
import 'package:great_quran/blocs/state_mix/generic_state.dart';
import 'package:great_quran/data/remote/apis/qibla_api.dart';
import 'package:great_quran/data/remote/interfaces/i_qibla_api.dart';


class QiblaDirectionNotifier extends StateNotifier<GenericState<double>>
    with DataFetcherForStateNotifier {
  static final provider =
      StateNotifierProvider<QiblaDirectionNotifier, GenericState<double>>(
          (ref) {
    return QiblaDirectionNotifier(ref.read(qiblaApiProvider));
  });
  final IQiblaApi _api;
  QiblaDirectionNotifier(this._api) : super(GenericState.initial());

  @override
  AsyncFetchFunction<double> get dataFetcher => () => _api.getQiblaDirection();
}
