import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/blocs/state_mix/_index.dart';
import 'package:great_quran/data/remote/apis/azan_api.dart';
import 'package:great_quran/data/remote/interfaces/i_azan_time_api.dart';

class AzanTimeNotifier extends StateNotifier<GenericState<Azan>> {
  static final provider =
      StateNotifierProvider<AzanTimeNotifier, GenericState<Azan>>((ref) {
    return AzanTimeNotifier(ref.read(AzanTimeApi.provider));
  });
  final IAzanTimeApi _iAzanTimeApi;
  AzanTimeNotifier(this._iAzanTimeApi) : super(GenericState.initial());

  Future<void> getAzan() async {
    try {
      state = GenericState.loading();
      final data = await _iAzanTimeApi.getAzan();
      state = GenericState.success(data);
    } catch (e, s) {
      state = GenericState.fail();
      debugPrint('Azan Notifier Error $e');
      debugPrint('Azan Notifier Error Stack $s');
    }
  }
}
