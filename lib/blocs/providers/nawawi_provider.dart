import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/nawawi/nawawi.dart';
import 'package:great_quran/blocs/states/generic_state.dart';
import 'package:great_quran/data/remote/apis/nawawi_api.dart';
import 'package:great_quran/data/remote/interfaces/i_nawawi_api.dart';

class NawawiNotifier extends StateNotifier<GenericState<List<Nawawi>>> {
  static final provider =
      StateNotifierProvider<NawawiNotifier, GenericState<List<Nawawi>>>((ref) {
    return NawawiNotifier(ref.read(NawawiApi.provider));
  });
  final INawawiApi _iNawawiApi;
  NawawiNotifier(this._iNawawiApi) : super(GenericState.initial());

  Future<void> getNawawi() async {
    try {
      state = GenericState.loading();
      final data = await _iNawawiApi.getNawawi();
      state = GenericState.success(data);
    } catch (e) {
      state = GenericState.fail();
      debugPrint('Error $e');
    }
  }
}
