import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:great_quran/feature/feelings/logic/models/feeling_item_model.dart';
import 'package:great_quran/feature/feelings/logic/repo/feelings_repository.dart';
import 'package:great_quran/feature/radios/logic/providers/audio_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final feelingsListProvider =
    FutureProvider<List<FeelingItemModel>>((ref) async {
  final repo = ref.watch(FeelingsRepository.provider);
  return repo.getFeelings();
});

enum VerseAudioStatus { initial, loading, playing, paused, error }

class VerseAudioState {
  final VerseAudioStatus status;
  final int activeAyahIndex;
  final String? errorMessage;

  const VerseAudioState({
    this.status = VerseAudioStatus.initial,
    this.activeAyahIndex = 0,
    this.errorMessage,
  });

  VerseAudioState copyWith({
    VerseAudioStatus? status,
    int? activeAyahIndex,
    String? errorMessage,
  }) {
    return VerseAudioState(
      status: status ?? this.status,
      activeAyahIndex: activeAyahIndex ?? this.activeAyahIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseAudioState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          activeAyahIndex == other.activeAyahIndex &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      status.hashCode ^ activeAyahIndex.hashCode ^ errorMessage.hashCode;
}

class FeelingAudioNotifier extends StateNotifier<VerseAudioState> {
  final Ref _ref;
  final AudioPlayer _player;
  int _currentPlaySession = 0;
  StreamSubscription<void>? _completeSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;

  FeelingAudioNotifier(this._ref, {AudioPlayer? player})
      : _player = player ?? AudioPlayer(),
        super(const VerseAudioState()) {
    _initSubscriptions();
  }

  void _initSubscriptions() {
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        state = state.copyWith(status: VerseAudioStatus.initial);
      }
    });

    _stateSubscription = _player.onPlayerStateChanged.listen((playerState) {
      if (!mounted) return;
      if (playerState == PlayerState.playing &&
          state.status != VerseAudioStatus.playing) {
        state = state.copyWith(status: VerseAudioStatus.playing);
      } else if (playerState == PlayerState.paused &&
          state.status != VerseAudioStatus.paused) {
        state = state.copyWith(status: VerseAudioStatus.paused);
      } else if (playerState == PlayerState.stopped &&
          state.status != VerseAudioStatus.initial) {
        state = state.copyWith(status: VerseAudioStatus.initial);
      }
    });
  }

  Future<void> playVerse(int index, String url) async {
    try {
      final radioNotifier = _ref.read(AudioNotifier.provider);
      if (radioNotifier.isPlaying) {
        await _ref.read(AudioNotifier.provider.notifier).togglePlayPause();
      }
    } catch (e) {
      debugPrint('Warning: unable to pause radio: $e');
    }

    final session = ++_currentPlaySession;
    state = state.copyWith(
      status: VerseAudioStatus.loading,
      activeAyahIndex: index,
      errorMessage: null,
    );

    try {
      await _player.stop();
      if (session != _currentPlaySession) return;

      await _player.play(UrlSource(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('انتهت مهلة الاتصال بخادم التلاوة');
        },
      );

      if (session != _currentPlaySession) {
        await _player.stop();
        return;
      }

      state = state.copyWith(status: VerseAudioStatus.playing);
    } catch (e) {
      if (session == _currentPlaySession && mounted) {
        debugPrint('Error playing verse audio: $e');
        state = state.copyWith(
          status: VerseAudioStatus.error,
          errorMessage: 'تعذر تشغيل التلاوة، يرجى التحقق من اتصال الإنترنت',
        );
      }
    }
  }

  Future<void> pauseVerse() async {
    try {
      await _player.pause();
      if (mounted) {
        state = state.copyWith(status: VerseAudioStatus.paused);
      }
    } catch (e) {
      debugPrint('Error pausing verse audio: $e');
    }
  }

  Future<void> stopVerse() async {
    try {
      await _player.stop();
      if (mounted) {
        state = state.copyWith(status: VerseAudioStatus.initial);
      }
    } catch (e) {
      debugPrint('Error stopping verse audio: $e');
    }
  }

  void onPageChanged(int newIndex) {
    _currentPlaySession++;
    _player.stop();
    state = VerseAudioState(
      activeAyahIndex: newIndex,
      status: VerseAudioStatus.initial,
    );
  }

  @override
  void dispose() {
    _currentPlaySession++;
    _completeSubscription?.cancel();
    _stateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }
}

final feelingAudioNotifierProvider =
    StateNotifierProvider.autoDispose<FeelingAudioNotifier, VerseAudioState>(
        (ref) {
  return FeelingAudioNotifier(ref);
});
