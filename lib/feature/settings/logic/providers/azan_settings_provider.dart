import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:great_quran/core/services/azan_audio_cache_service.dart';
import 'package:great_quran/feature/azan/logic/providers/azan_provider.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/repo/azan_settings_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzanSettingsNotifier
    extends StateNotifier<AsyncValue<AzanNotificationPreferences>> {
  static final provider = StateNotifierProvider<AzanSettingsNotifier,
      AsyncValue<AzanNotificationPreferences>>((ref) {
    return AzanSettingsNotifier(
      ref.read(AzanSettingsRepository.provider),
      ref.read(AzanAudioCacheService.provider),
      ref,
    );
  });

  final IAzanSettingsRepository _repository;
  final AzanAudioCacheService _cacheService;
  final Ref _ref;
  final AudioPlayer _audioPlayer = AudioPlayer();
  AzanVoice? _currentlyPlayingVoice;

  AzanSettingsNotifier(this._repository, this._cacheService, this._ref)
      : super(const AsyncValue.loading()) {
    loadPreferences();
    _audioPlayer.onPlayerComplete.listen((_) {
      _currentlyPlayingVoice = null;
      if (mounted && state.hasValue) {
        state = AsyncValue.data(state.value!);
      }
    });
  }

  AzanVoice? get currentlyPlayingVoice => _currentlyPlayingVoice;

  Future<void> loadPreferences() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getPreferences());
  }

  Future<void> updatePreferences(AzanNotificationPreferences prefs) async {
    await _repository.savePreferences(prefs);
    state = AsyncValue.data(prefs);
  }

  Future<void> setDaylightSavingMode(DaylightSavingMode mode) async {
    final current = state.value ?? const AzanNotificationPreferences();
    final updated = current.copyWith(daylightSavingMode: mode);
    await updatePreferences(updated);
    try {
      await _ref.read(AzanTimeNotifier.provider.notifier).getAzan();
    } catch (_) {}
  }

  Future<void> setMinuteAdjustment(int minutes) async {
    final current = state.value ?? const AzanNotificationPreferences();
    final updated = current.copyWith(minuteAdjustment: minutes);
    await updatePreferences(updated);
    try {
      await _ref.read(AzanTimeNotifier.provider.notifier).getAzan();
    } catch (_) {}
  }

  Future<void> setVoice(AzanVoice voice) async {
    final current = state.value ?? const AzanNotificationPreferences();
    final updated = current.copyWith(selectedVoice: voice);
    await updatePreferences(updated);
  }

  Future<void> toggleEnabled(bool isEnabled) async {
    final current = state.value ?? const AzanNotificationPreferences();
    final updated = current.copyWith(isEnabled: isEnabled);
    await updatePreferences(updated);
  }

  Future<void> togglePrayer(String prayer, bool isEnabled) async {
    final current = state.value ?? const AzanNotificationPreferences();
    AzanNotificationPreferences updated;
    switch (prayer) {
      case 'fajr':
        updated = current.copyWith(fajr: isEnabled);
        break;
      case 'dhuhr':
        updated = current.copyWith(dhuhr: isEnabled);
        break;
      case 'asr':
        updated = current.copyWith(asr: isEnabled);
        break;
      case 'maghrib':
        updated = current.copyWith(maghrib: isEnabled);
        break;
      case 'isha':
        updated = current.copyWith(isha: isEnabled);
        break;
      default:
        updated = current;
    }
    await updatePreferences(updated);
  }

  Future<void> toggleVoicePreview(AzanVoice voice) async {
    if (_currentlyPlayingVoice == voice) {
      try {
        await _audioPlayer.stop();
      } catch (_) {}
      _currentlyPlayingVoice = null;
    } else {
      try {
        await _audioPlayer.stop();
        if (voice.sampleUrl.isNotEmpty) {
          _currentlyPlayingVoice = voice;
          if (mounted && state.hasValue) {
            state = AsyncValue.data(state.value!);
          }

          // Try playing from local cache first
          final cachedPath = await _cacheService.getCachedFilePath(voice);
          if (cachedPath != null && await File(cachedPath).exists()) {
            await _audioPlayer.play(
              DeviceFileSource(cachedPath),
              mode: PlayerMode.mediaPlayer,
            );
          } else {
            // Attempt to cache while playing or download then play
            try {
              final newPath = await _cacheService.ensureCached(voice);
              if (newPath != null && await File(newPath).exists()) {
                await _audioPlayer.play(
                  DeviceFileSource(newPath),
                  mode: PlayerMode.mediaPlayer,
                );
              } else {
                await _audioPlayer.play(
                  UrlSource(voice.sampleUrl),
                  mode: PlayerMode.mediaPlayer,
                );
              }
            } catch (_) {
              await _audioPlayer.play(
                UrlSource(voice.sampleUrl),
                mode: PlayerMode.mediaPlayer,
              );
            }
          }
        } else {
          _currentlyPlayingVoice = null;
        }
      } catch (_) {
        _currentlyPlayingVoice = null;
      }
    }
    if (mounted && state.hasValue) {
      state = AsyncValue.data(state.value!);
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}
