import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:great_quran/feature/radios/logic/providers/radio_audio_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AudioNotifier extends ChangeNotifier {
  static final provider = ChangeNotifierProvider<AudioNotifier>((ref) {
    final handler = ref.watch(radioAudioHandlerProvider);
    return AudioNotifier(handler: handler);
  });

  final RadioAudioHandler? _handler;
  final AudioPlayer _fallbackPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _isLoading = false;

  List<RadioDetalis> _playlist = [];
  int _currentIndex = 0;
  bool _isDisposed = false;

  StreamSubscription<PlaybackState>? _playbackStateSub;
  StreamSubscription<MediaItem?>? _mediaItemSub;
  StreamSubscription<PlayerState>? _fallbackSub;

  AudioNotifier({RadioAudioHandler? handler}) : _handler = handler {
    _initSubscriptions();
  }

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  int get currentIndex => _currentIndex;
  int get totalCount => _playlist.length;
  List<RadioDetalis> get playlist => _playlist;

  RadioDetalis? get currentRadio =>
      (_playlist.isNotEmpty && _currentIndex < _playlist.length)
          ? _playlist[_currentIndex]
          : null;

  bool get hasNext => _currentIndex < _playlist.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _initSubscriptions() {
    final handler = _handler;
    if (handler != null) {
      _playbackStateSub = handler.playbackState.listen((state) {
        _isPlaying = state.playing;
        _isLoading = state.processingState == AudioProcessingState.buffering;
        _safeNotify();
      });

      _mediaItemSub = handler.mediaItem.listen((item) {
        if (item != null && _playlist.isNotEmpty) {
          final foundIndex = _playlist.indexWhere((r) => r.url == item.id);
          if (foundIndex != -1 && foundIndex != _currentIndex) {
            _currentIndex = foundIndex;
            _safeNotify();
          }
        }
      });
    } else {
      _fallbackSub = _fallbackPlayer.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
        _safeNotify();
      });
    }
  }

  Future<void> initPlaylist(
      List<RadioDetalis> playlist, int initialIndex) async {
    final targetIndex =
        initialIndex.clamp(0, playlist.isEmpty ? 0 : playlist.length - 1);
    final targetRadio = playlist.isNotEmpty ? playlist[targetIndex] : null;

    if (targetRadio != null &&
        currentRadio?.url == targetRadio.url &&
        _isPlaying) {
      _playlist = playlist;
      _currentIndex = targetIndex;
      _safeNotify();
      return;
    }

    _playlist = playlist;
    _currentIndex = targetIndex;
    _safeNotify();

    final handler = _handler;
    if (handler != null) {
      await handler.setPlaylist(playlist, _currentIndex);
    } else {
      if (_playlist.isNotEmpty) {
        await _playFallbackUrl(_playlist[_currentIndex].url);
      }
    }
  }

  Future<void> _playFallbackUrl(String url) async {
    try {
      _isLoading = true;
      _safeNotify();
      await _fallbackPlayer.stop();
      await _fallbackPlayer.play(UrlSource(url));
      _isPlaying = true;
    } catch (e) {
      debugPrint("Error playing audio stream in fallback: $e");
      _isPlaying = false;
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> togglePlayPause() async {
    if (currentRadio == null) return;

    final handler = _handler;
    if (handler != null) {
      if (_isPlaying) {
        await handler.pause();
      } else {
        await handler.play();
      }
    } else {
      if (_isPlaying) {
        await _fallbackPlayer.stop();
        _isPlaying = false;
        _safeNotify();
      } else {
        await _playFallbackUrl(currentRadio!.url);
      }
    }
  }

  Future<void> playNext() async {
    final handler = _handler;
    if (handler != null) {
      await handler.skipToNext();
      _currentIndex = handler.currentIndex;
      _safeNotify();
    } else if (hasNext) {
      _currentIndex++;
      _safeNotify();
      await _playFallbackUrl(_playlist[_currentIndex].url);
    }
  }

  Future<void> playPrevious() async {
    final handler = _handler;
    if (handler != null) {
      await handler.skipToPrevious();
      _currentIndex = handler.currentIndex;
      _safeNotify();
    } else if (hasPrevious) {
      _currentIndex--;
      _safeNotify();
      await _playFallbackUrl(_playlist[_currentIndex].url);
    }
  }

  Future<void> selectStation(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      _safeNotify();

      final handler = _handler;
      if (handler != null) {
        await handler.skipToQueueItem(index);
      } else {
        await _playFallbackUrl(_playlist[_currentIndex].url);
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _playbackStateSub?.cancel();
    _mediaItemSub?.cancel();
    _fallbackSub?.cancel();
    if (_handler == null) {
      _fallbackPlayer.stop();
      _fallbackPlayer.dispose();
    }
    super.dispose();
  }
}
