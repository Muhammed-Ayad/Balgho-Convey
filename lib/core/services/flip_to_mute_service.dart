import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/core/services/notification_scheduler_service.dart';
import 'package:great_quran/feature/settings/logic/providers/azan_settings_provider.dart';
import 'package:great_quran/feature/settings/logic/repo/azan_settings_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlipToMuteService {
  static const MethodChannel _channel =
      MethodChannel('com.convey.ayah.mohamed.ayad/flip_to_mute');

  static final provider = Provider<FlipToMuteService>((ref) {
    return FlipToMuteService(
      ref.read(AzanSettingsRepository.provider),
      ref.read(LocalNotificationService.provider),
      ref,
    );
  });

  final IAzanSettingsRepository _azanSettingsRepository;
  final LocalNotificationService _notificationService;
  final Ref _ref;
  bool _isInitialized = false;

  FlipToMuteService(
    this._azanSettingsRepository,
    this._notificationService,
    this._ref,
  );

  void initialize() {
    if (_isInitialized) return;
    _isInitialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeviceFlippedFaceDown') {
        await _handleDeviceFlipped();
      }
    });

    try {
      _channel.invokeMethod('startListening');
      debugPrint("FlipToMuteService: Listening for flip events initialized.");
    } catch (e) {
      debugPrint("FlipToMuteService: Failed to start listening: $e");
    }
  }

  Future<void> _handleDeviceFlipped() async {
    try {
      final prefs = await _azanSettingsRepository.getPreferences();
      if (!prefs.flipToMute) {
        debugPrint(
            "FlipToMuteService: Flip detected, but flipToMute is disabled in settings.");
        return;
      }

      debugPrint(
          "FlipToMuteService: Phone flipped face down! Muting and stopping azan audio.");

      // 1. Stop audio preview if currently playing
      try {
        await _ref.read(AzanSettingsNotifier.provider.notifier).stopAudioPreview();
      } catch (_) {}

      // 2. Dismiss active prayer azan notifications from notification tray
      final prayerIds = [
        NotificationSchedulerService.idFajr,
        NotificationSchedulerService.idDhuhr,
        NotificationSchedulerService.idAsr,
        NotificationSchedulerService.idMaghrib,
        NotificationSchedulerService.idIsha,
        NotificationSchedulerService.idTestNotification,
      ];

      for (final id in prayerIds) {
        await _notificationService.cancel(id);
      }
    } catch (e, s) {
      debugPrint("FlipToMuteService: Error handling flip: $e\n$s");
    }
  }

  void dispose() {
    try {
      _channel.invokeMethod('stopListening');
    } catch (_) {}
  }
}
