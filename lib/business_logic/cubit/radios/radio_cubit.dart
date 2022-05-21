import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/radios/radios.dart';

import '../../../data/models/custom_error.dart';
import '../../../data/repository/radios_repository.dart';

part 'radio_state.dart';

class RadioCubit extends Cubit<RadioState> {
  final RadiosRepository radiosRepository;

  RadioCubit({
    required this.radiosRepository,
  }) : super(RadioState.initial()) {
    fetchRadios();
  }

  Future<void> fetchRadios() async {
    emit(state.copyWith(status: RadioStatus.loading));

    try {
      final List<Radios> radiosList = await radiosRepository.fetchRadios();
      emit(state.copyWith(status: RadioStatus.loaded, radio: radiosList));
    } on CustomError catch (e) {
      emit(state.copyWith(status: RadioStatus.error, error: e));
    }
  }
}
