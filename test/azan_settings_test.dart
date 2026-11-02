import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/repo/azan_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AzanNotificationDetails tests', () {
    test('Configures raw sound for each muezzin voice accurately', () {
      for (final voice in AzanVoice.values) {
        final details = LocalNotificationService.getAzanNotificationDetails(voice);
        final android = details.android;
        expect(android, isNotNull);

        if (voice == AzanVoice.silent) {
          expect(android!.playSound, false);
          expect(android.sound, isNull);
        } else {
          expect(android!.playSound, true);
          expect(android.sound, isA<RawResourceAndroidNotificationSound>());
          final soundResource =
              (android.sound as RawResourceAndroidNotificationSound).sound;
          expect(soundResource, 'azan_${voice.name}');
          expect(android.channelId, 'convey_azan_channel_${voice.name}_v2');
          expect(android.audioAttributesUsage, AudioAttributesUsage.alarm);
        }
      }
    });
  });

  group('AzanSettingsRepository tests', () {
    test('Default preferences loaded accurately', () async {
      final repo = AzanSettingsRepository();
      final prefs = await repo.getPreferences();

      expect(prefs.isEnabled, true);
      expect(prefs.selectedVoice, AzanVoice.makkah);
      expect(prefs.fajr, true);
    });

    test('Saving preferences updates persistent store', () async {
      final repo = AzanSettingsRepository();
      const newPrefs = AzanNotificationPreferences(
        isEnabled: false,
        selectedVoice: AzanVoice.aqsa,
        fajr: false,
      );

      await repo.savePreferences(newPrefs);
      final loaded = await repo.getPreferences();

      expect(loaded.isEnabled, false);
      expect(loaded.selectedVoice, AzanVoice.aqsa);
      expect(loaded.fajr, false);
    });

    test('DaylightSavingMode serialization and default values', () async {
      final repo = AzanSettingsRepository();
      const prefs = AzanNotificationPreferences(
        daylightSavingMode: DaylightSavingMode.summer,
        minuteAdjustment: 5,
        flipToMute: false,
      );

      await repo.savePreferences(prefs);
      final loaded = await repo.getPreferences();

      expect(loaded.daylightSavingMode, DaylightSavingMode.summer);
      expect(loaded.minuteAdjustment, 5);
      expect(loaded.flipToMute, false);
      expect(loaded.daylightSavingMode.title, "التوقيت الصيفي (+1 ساعة)");
    });

    test('FlipToMute defaults to true and serializes accurately', () async {
      final repo = AzanSettingsRepository();
      final defaults = await repo.getPreferences();
      expect(defaults.flipToMute, true);

      final modified = defaults.copyWith(flipToMute: false);
      await repo.savePreferences(modified);

      final loaded = await repo.getPreferences();
      expect(loaded.flipToMute, false);
    });
  });
}
