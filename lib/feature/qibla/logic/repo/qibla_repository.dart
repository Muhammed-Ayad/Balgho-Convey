import 'dart:math' as math;
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/services/location_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IQiblaRepository {
  Future<double> getQiblaDirection();
}

class QiblaRepository implements IQiblaRepository {
  static final provider = Provider<IQiblaRepository>(
    (ref) => QiblaRepository(
      ref.read(LocationService.provider),
    ),
  );

  final LocationService _locationService;
  QiblaRepository(this._locationService);

  // إحداثيات الكعبة المشرفة في مكة المكرمة
  static const double _kaabaLat = 21.422487;
  static const double _kaabaLng = 39.826206;

  // إحداثيات افتراضية للقاهرة
  static const double _defaultLat = 30.0444;
  static const double _defaultLng = 31.2357;

  @override
  Future<double> getQiblaDirection() async {
    double? lat;
    double? lng;

    try {
      final locationData = await _locationService.getCurrentLocation();
      if (locationData != null &&
          locationData.latitude != null &&
          locationData.longitude != null) {
        lat = locationData.latitude!;
        lng = locationData.longitude!;
      }
    } catch (_) {}

    if (lat == null || lng == null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        lat = prefs.getDouble('cached_azan_lat');
        lng = prefs.getDouble('cached_azan_lng');
      } catch (_) {}
    }

    lat ??= _defaultLat;
    lng ??= _defaultLng;

    final direction = _calculateQibla(lat, lng);
    "Qibla Direction calculated: $direction° from N".log();
    return direction;
  }

  double _calculateQibla(double latitude, double longitude) {
    const double degToRad = math.pi / 180.0;
    final double phi1 = latitude * degToRad;
    const double phi2 = _kaabaLat * degToRad;
    final double deltaLambda = (_kaabaLng - longitude) * degToRad;

    final double y = math.sin(deltaLambda) * math.cos(phi2);
    final double x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    final double theta = math.atan2(y, x);
    final double bearing = (theta * (180.0 / math.pi) + 360.0) % 360.0;
    return double.parse(bearing.toStringAsFixed(2));
  }
}
