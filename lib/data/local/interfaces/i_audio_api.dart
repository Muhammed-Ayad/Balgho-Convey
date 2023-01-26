import 'package:great_quran/blocs/models/radios/radio.dart';

abstract class IAudioApi {
  Future<RadioDetalis> next(int currentAudioIndex);

  Future<RadioDetalis> previous(int currentAudioIndex);
}
