import 'package:great_quran/feature/radios/logic/models/radios.dart';
import 'package:great_quran/feature/radios/logic/repo/radios_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RadiosNotifier extends StateNotifier<AsyncValue<List<Radios>>> {
  static final provider =
      StateNotifierProvider<RadiosNotifier, AsyncValue<List<Radios>>>((ref) {
    return RadiosNotifier(ref.read(RadiosRepository.provider));
  });

  final IRadiosRepository _repository;
  RadiosNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> getRadios() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getRadios());
  }
}
