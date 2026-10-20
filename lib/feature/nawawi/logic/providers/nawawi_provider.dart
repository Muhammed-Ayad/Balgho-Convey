import 'package:great_quran/feature/nawawi/logic/models/nawawi.dart';
import 'package:great_quran/feature/nawawi/logic/repo/nawawi_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NawawiNotifier extends StateNotifier<AsyncValue<List<Nawawi>>> {
  static final provider =
      StateNotifierProvider<NawawiNotifier, AsyncValue<List<Nawawi>>>((ref) {
    return NawawiNotifier(ref.read(NawawiRepository.provider));
  });

  final INawawiRepository _nawawiRepository;
  NawawiNotifier(this._nawawiRepository) : super(const AsyncValue.loading());

  Future<void> getNawawi() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _nawawiRepository.getNawawi());
  }
}
