import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:great_quran/feature/azan/logic/repo/azan_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzanTimeNotifier extends StateNotifier<AsyncValue<Azan>> {
  static final provider =
      StateNotifierProvider<AzanTimeNotifier, AsyncValue<Azan>>((ref) {
    return AzanTimeNotifier(ref.read(AzanRepository.provider));
  });

  final IAzanRepository _azanRepository;
  AzanTimeNotifier(this._azanRepository)
      : super(AsyncValue.data(_azanRepository.getInitialAzan())) {
    _initFromCache();
  }

  Future<void> _initFromCache() async {
    final cached = await _azanRepository.getCachedAzan();
    if (cached != null) {
      state = AsyncValue.data(cached);
    }
  }

  Future<void> getAzan() async {
    try {
      final azan = await _azanRepository.getAzan();
      state = AsyncValue.data(azan);
    } catch (e, stack) {
      if (!state.hasValue) {
        state = AsyncValue.error(e, stack);
      }
    }
  }
}
