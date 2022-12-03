import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/quran/surah.dart';
import 'package:great_quran/blocs/states/generic_state.dart';
import 'package:great_quran/data/remote/apis/quran_api.dart';
import 'package:great_quran/data/remote/interfaces/i_quran_api.dart';

class QuranNotifier extends StateNotifier<GenericState<List<Surah>>> {
  static final provider =
      StateNotifierProvider<QuranNotifier, GenericState<List<Surah>>>((ref) {
    return QuranNotifier(ref.read(QuranApi.provider));
  });
  final IQuranApi _iQuranApi;
  QuranNotifier(this._iQuranApi) : super(GenericState.initial());

  Future<void> getQuran() async {
    try {
      state = GenericState.loading();
      final data = await _iQuranApi.getQuran();
      state = GenericState.success(data);
    } catch (e) {
      state = GenericState.fail();
      debugPrint('Error $e');
    }
  }
}
