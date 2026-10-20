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
      final isServiceAvailable = await checkLocationServiceAvailability();

      if (isServiceAvailable) {
        return await location.getLocation();
      }
    } catch (e) {
      e.log();
    }
    return null;
  }

  Future<bool> checkLocationServiceAvailability() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    if (!kIsWeb) {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location service is not enabled");
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          return false;
        }
      }
    }

    return true;
  }
}
