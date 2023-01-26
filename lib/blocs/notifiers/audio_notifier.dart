import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioNotifier extends ChangeNotifier {
  static final provider =
      ChangeNotifierProvider.autoDispose<AudioNotifier>((ref) {
    return AudioNotifier();
  });

  AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;

  bool isPlaying() => _isPlaying;

  void init(String url) {
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(url);
    _isPlaying = true;
    _listenRadio();
    notifyListeners();
  }

  void _listenRadio() {
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
    });
    notifyListeners();
  }

  Future<void> playMusic(String url) async {
    await _audioPlayer.play(url);
    notifyListeners();
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
    notifyListeners();
  }

  void onPressed(String url) {
    if (isPlaying()) {
      stopMusic();
    } else {
      playMusic(url);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
