import 'package:great_quran/blocs/models/radios/radio.dart';
import 'package:great_quran/data/local/interfaces/i_audio_api.dart';

class AudioApi extends IAudioApi {
  @override
  Future<RadioDetails> next(int currentAudioIndex) {
    throw UnimplementedError();
  }

  @override
  Future<RadioDetails> previous(int currentAudioIndex) {
    throw UnimplementedError();
  }
}
