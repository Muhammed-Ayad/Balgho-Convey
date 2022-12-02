part of 'quran_cubit.dart';

enum QuranStatus {
  initial,
  loading,
  loaded,
  error,
}

class QuranState extends Equatable {
  final QuranStatus status;
  final List<Surah> surah;
  final CustomError error;
  const QuranState({
    required this.status,
    required this.surah,
    required this.error,
  });

  @override
  List<Object> get props => [status, surah, error];

  factory QuranState.initial() {
    return const QuranState(
      status: QuranStatus.initial,
      surah: [],
      error: CustomError(),
    );
  }

  QuranState copyWith({
    QuranStatus? status,
    List<Surah>? surah,
    CustomError? error,
  }) {
    return QuranState(
      status: status ?? this.status,
      surah: surah ?? this.surah,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'QuranState(status: $status, surah: $surah, error: $error)';
}
