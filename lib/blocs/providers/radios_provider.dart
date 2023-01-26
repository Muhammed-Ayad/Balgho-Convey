import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/radios/radios.dart';
import 'package:great_quran/blocs/state_mix/state_mix.dart';
import 'package:great_quran/data/remote/apis/radios_api.dart';
import 'package:great_quran/data/remote/interfaces/i_radios_api.dart';

class RadiosNotifier extends StateNotifier<GenericState<List<Radios>>> {
  static final provider =
      StateNotifierProvider<RadiosNotifier, GenericState<List<Radios>>>((ref) {
    return RadiosNotifier(ref.read(RadiosApi.provider));
  });
  final IRadiosApi _iRadiosApi;
  RadiosNotifier(this._iRadiosApi) : super(GenericState.initial());

  Future<void> getRadios() async {
    try {
      state = GenericState.loading();
      final data = await _iRadiosApi.getRadios();
      state = GenericState.success(data);
    } catch (e) {
      state = GenericState.fail();
      debugPrint('Radios Notifier Error $e');
    }
  }
}
