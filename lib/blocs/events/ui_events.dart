import 'package:great_quran/blocs/events/app_event.dart';

class UiEvent extends AppEvent {
  const UiEvent(super.isUrgent);
}

class UrgentUiEvent extends UiEvent {
  final String message;
  const UrgentUiEvent(this.message) : super(true);
}

class NormalUiEvent extends UiEvent {
  final String message;
  const NormalUiEvent(this.message) : super(false);
}
