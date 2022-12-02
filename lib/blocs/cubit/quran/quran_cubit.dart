import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/custom_error.dart';
import '../../../data/models/quran/surah.dart';
import '../../../data/repository/quran_repository.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranRepository quranRepository;
  QuranCubit({
    required this.quranRepository,
  }) : super(QuranState.initial()) {
    fetchQuran();
  }

  Future<void> fetchQuran() async {
    emit(state.copyWith(status: QuranStatus.loading));

    try {
      final List<Surah> surahsList = await quranRepository.fetchQuran();
      emit(state.copyWith(status: QuranStatus.loaded, surah: surahsList));
    } on CustomError catch (e) {
      emit(state.copyWith(error: e, status: QuranStatus.error));
    }
  }
}
