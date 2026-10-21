import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/qibla/logic/repo/qibla_repository.dart';
import 'package:great_quran/core/services/location_service.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocationService extends LocationService {
  final double lat;
  final double lng;
  MockLocationService(this.lat, this.lng);

  @override
  Future<LocationData?> getCurrentLocation() async {
    return LocationData.fromMap({
      'latitude': lat,
      'longitude': lng,
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Offline Qibla calculation tests', () {
    test('Calculates Cairo Qibla direction correctly (~136 degrees)', () async {
      // Cairo coordinates: 30.0444° N, 31.2357° E
      final mockLocation = MockLocationService(30.0444, 31.2357);
      final repo = QiblaRepository(mockLocation);

      final bearing = await repo.getQiblaDirection();

      // Qibla from Cairo is approx 136°
      expect(bearing, greaterThan(134.0));
      expect(bearing, lessThan(138.0));
    });

    test('Falls back gracefully when LocationData is null', () async {
      final emptyLocation = LocationService();
      final repo = QiblaRepository(emptyLocation);

      final bearing = await repo.getQiblaDirection();
      expect(bearing, greaterThan(0.0));
    });

    test('Calculates Medina Qibla direction correctly (due South ~176 degrees)',
        () async {
      // Medina coordinates: 24.4672° N, 39.6111° E
      final mockLocation = MockLocationService(24.4672, 39.6111);
      final repo = QiblaRepository(mockLocation);

      final bearing = await repo.getQiblaDirection();

      // From Medina, Kaaba is almost directly south
      expect(bearing, greaterThan(170.0));
      expect(bearing, lessThan(180.0));
    });
  });
}
