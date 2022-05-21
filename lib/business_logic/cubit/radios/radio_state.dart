part of 'radio_cubit.dart';

enum RadioStatus { initial, loading, loaded, error }

class RadioState extends Equatable {
  final RadioStatus status;
  final List<Radios> radio;
  final CustomError error;
  const RadioState({
    required this.status,
    required this.radio,
    required this.error,
  });

  @override
  List<Object> get props => [status, radio, error];

  factory RadioState.initial() {
    return const RadioState(
      status: RadioStatus.initial,
      radio: [],
      error: CustomError(),
    );
  }

  RadioState copyWith({
    RadioStatus? status,
    List<Radios>? radio,
    CustomError? error,
  }) {
    return RadioState(
      status: status ?? this.status,
      radio: radio ?? this.radio,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'RadioState(status: $status, radio: $radio, error: $error)';
}
