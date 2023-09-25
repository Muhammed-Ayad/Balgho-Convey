import 'package:great_quran/blocs/models/radios/radio.dart';

abstract class IAudioApi {
  Future<RadioDetails> next(int currentAudioIndex);

  Future<RadioDetails> previous(int currentAudioIndex);
}
