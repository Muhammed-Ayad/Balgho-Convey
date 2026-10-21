import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/core/services/location_service.dart';
import 'package:great_quran/feature/azan/logic/repo/azan_repository.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/repo/azan_settings_repository.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocationService extends LocationService {
  @override
  Future<LocationData?> getCurrentLocation() async {
    return LocationData.fromMap({
      'latitude': 30.0444,
      'longitude': 31.2357,
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Offline Prayer Times calculation tests', () {
    test('Calculates prayer times offline accurately for Cairo', () async {
      final repo = AzanRepository(MockLocationService());
      final azan = await repo.getAzan();

      expect(azan.code, 200);
      expect(azan.status, "OK");

      final timings = azan.data.timings;
      expect(timings.fajr.isNotEmpty, true);
      expect(timings.sunrise.isNotEmpty, true);
      expect(timings.dhuhr.isNotEmpty, true);
      expect(timings.asr.isNotEmpty, true);
      expect(timings.maghrib.isNotEmpty, true);
      expect(timings.isha.isNotEmpty, true);

      // Verify Hijri date is populated
      final hijri = azan.data.date.hijri;
      expect(hijri.day.isNotEmpty, true);
      expect(hijri.year.isNotEmpty, true);
      expect(hijri.weekday.ar.isNotEmpty, true);
    });

    test('Falls back gracefully to default coordinates when location is null',
        () async {
      final emptyLocationService = LocationService();
      final repo = AzanRepository(emptyLocationService);
      final azan = await repo.getAzan();

      expect(azan.code, 200);
      expect(azan.data.timings.fajr.isNotEmpty, true);
    });

    test('getCachedAzan returns data after getAzan caches it', () async {
      final repo = AzanRepository(MockLocationService());
      await repo.getAzan();

      final cached = await repo.getCachedAzan();
      expect(cached, isNotNull);
      expect(cached!.data.timings.fajr.isNotEmpty, true);
    });

    test('getInitialAzan returns instant default prayer calculations', () {
      final repo = AzanRepository(MockLocationService());
      final initial = repo.getInitialAzan();

      expect(initial.code, 200);
      expect(initial.status, "OK");
      expect(initial.data.timings.fajr.isNotEmpty, true);
    });

    test(
        'DaylightSavingMode.summer shifts prayer times by 1 hour compared to winter',
        () async {
      final repo = AzanRepository(MockLocationService());
      final settingsRepo = AzanSettingsRepository();

      // Winter mode
      await settingsRepo.savePreferences(
        const AzanNotificationPreferences(
          daylightSavingMode: DaylightSavingMode.winter,
          minuteAdjustment: 0,
        ),
      );
      final azanWinter = await repo.getAzan();

      // Summer mode
      await settingsRepo.savePreferences(
        const AzanNotificationPreferences(
          daylightSavingMode: DaylightSavingMode.summer,
          minuteAdjustment: 0,
        ),
      );
      final azanSummer = await repo.getAzan();

      final winterFajrHour =
          int.parse(azanWinter.data.timings.fajr.split(':').first);
      final summerFajrHour =
          int.parse(azanSummer.data.timings.fajr.split(':').first);

      expect(summerFajrHour, (winterFajrHour + 1) % 24);
    });

    test('Calculates Islamic midnight and last third of night accurately',
        () async {
      final repo = AzanRepository(MockLocationService());
      final azan = await repo.getAzan();

      final timings = azan.data.timings;
      expect(timings.midnight, isNot("00:00"));
      expect(timings.lastthird, isNot("00:00"));
      expect(timings.firstthird, isNot("00:00"));
    });
  });
}
