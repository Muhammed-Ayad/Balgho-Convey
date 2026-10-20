import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:great_quran/feature/azan/logic/repo/azan_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzanTimeNotifier extends StateNotifier<AsyncValue<Azan>> {
  static final provider =
      StateNotifierProvider<AzanTimeNotifier, AsyncValue<Azan>>((ref) {
    return AzanTimeNotifier(ref.read(AzanRepository.provider));
  });

  final IAzanRepository _azanRepository;
  AzanTimeNotifier(this._azanRepository) : super(const AsyncValue.loading());

  Future<void> getAzan() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _azanRepository.getAzan());
  }
}
