import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final radioAudioHandlerProvider = Provider<RadioAudioHandler?>((ref) => null);

class RadioAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  List<RadioDetalis> _playlist = [];
  int _currentIndex = 0;
  bool _isLoading = false;

  StreamSubscription<PlayerState>? _playerStateSub;

  List<RadioDetalis> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;

  RadioAudioHandler() {
    _initAudioService();
  }

  Future<void> _initAudioService() async {
    try {
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {
              AVAudioSessionOptions.defaultToSpeaker,
            },
          ),
          android: const AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error setting global audio context: $e");
    }

    _playerStateSub = _player.onPlayerStateChanged.listen((state) {
      final isPlaying = state == PlayerState.playing;

      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: _isLoading
            ? AudioProcessingState.buffering
            : AudioProcessingState.ready,
        playing: isPlaying,
      ));
    });
  }

  Future<void> setPlaylist(
      List<RadioDetalis> playlist, int initialIndex) async {
    _playlist = playlist;
    _currentIndex =
        initialIndex.clamp(0, playlist.isEmpty ? 0 : playlist.length - 1);

    final mediaItems = playlist.asMap().entries.map((entry) {
      return MediaItem(
        id: entry.value.url,
        album: "إذاعات القرآن الكريم - تطبيق بلغوا",
        title: entry.value.name,
        displayTitle: entry.value.name,
        displaySubtitle: "تطبيق بلغوا - بث مباشر",
      );
    }).toList();

    queue.add(mediaItems);

    if (_playlist.isNotEmpty) {
      await _playCurrent();
    }
  }

  Future<void> _playCurrent() async {
    if (_playlist.isEmpty || _currentIndex >= _playlist.length) return;

    final current = _playlist[_currentIndex];
    _isLoading = true;

    if (queue.value.isNotEmpty && _currentIndex < queue.value.length) {
      mediaItem.add(queue.value[_currentIndex]);
    }

    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.buffering,
      playing: true,
    ));

    try {
      await _player.stop();
      await _player.play(UrlSource(current.url));
    } catch (e) {
      debugPrint("Error playing radio station: $e");
    } finally {
      _isLoading = false;
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.ready,
      ));
    }
  }

  @override
  Future<void> play() async {
    if (_playlist.isEmpty) return;
    await _playCurrent();
  }

  @override
  Future<void> pause() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.ready,
    ));
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
  }

  @override
  Future<void> skipToNext() async {
    if (_playlist.isEmpty) return;
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0; // حلقة دائرية للتنقل بين المحطات
    }
    await _playCurrent();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_playlist.isEmpty) return;
    if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      _currentIndex = _playlist.length - 1; // حلقة دائرية
    }
    await _playCurrent();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await _playCurrent();
    }
  }

  Future<void> disposeHandler() async {
    _playerStateSub?.cancel();
    await _player.stop();
    await _player.dispose();
  }
}
