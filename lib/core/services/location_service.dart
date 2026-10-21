import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:location/location.dart';

class LocationService {
  static final provider = Provider<LocationService>(
    (ref) => LocationService(),
  );

  final location = Location();
  Future<LocationData?> getCurrentLocation() async {
    try {
      final isServiceAvailable = await checkLocationServiceAvailability()
          .timeout(const Duration(seconds: 3), onTimeout: () => false);

      if (isServiceAvailable) {
        return await location.getLocation().timeout(
          const Duration(seconds: 4),
          onTimeout: () {
            "Location fetch timed out, falling back to cached coordinates"
                .log();
            return LocationData.fromMap({});
          },
        );
      }
    } catch (e) {
      e.log();
    }
    return null;
  }

  Future<bool> checkLocationServiceAvailability() async {
    if (kIsWeb) return true;

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
      }

      return permissionStatus == PermissionStatus.granted ||
          permissionStatus == PermissionStatus.grantedLimited;
    } catch (e) {
      debugPrint("Location service availability check error: $e");
      return false;
    }
  }
}
