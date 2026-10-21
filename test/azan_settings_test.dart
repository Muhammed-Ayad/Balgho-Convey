import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/repo/azan_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
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
      );

      await repo.savePreferences(prefs);
      final loaded = await repo.getPreferences();

      expect(loaded.daylightSavingMode, DaylightSavingMode.summer);
      expect(loaded.minuteAdjustment, 5);
      expect(loaded.daylightSavingMode.title, "التوقيت الصيفي (+1 ساعة)");
    });
  });
}
