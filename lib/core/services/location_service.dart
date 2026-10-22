import 'package:flutter/foundation.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';

class LocationService {
  static final provider = Provider<LocationService>(
    (ref) => LocationService(),
  );

  final location = Location();

  Future<bool> hasPermission() async {
    if (kIsWeb) return true;
    try {
      final status = await location.hasPermission();
      return status == PermissionStatus.granted ||
          status == PermissionStatus.grantedLimited;
    } catch (e) {
      debugPrint("Location hasPermission check error: $e");
      return false;
    }
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) return true;
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      PermissionStatus status = await location.hasPermission();
      if (status == PermissionStatus.denied) {
        status = await location.requestPermission();
      }

      return status == PermissionStatus.granted ||
          status == PermissionStatus.grantedLimited;
    } catch (e) {
      debugPrint("Location requestPermission error: $e");
      return false;
    }
  }

  Future<LocationData?> getCurrentLocation({bool allowPrompt = false}) async {
    try {
      final isPermitted =
          allowPrompt ? await requestPermission() : await hasPermission();

      if (!isPermitted) {
        return null;
      }

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled && allowPrompt) {
        serviceEnabled = await location.requestService();
      }
      if (!serviceEnabled) {
        return null;
      }

      return await location.getLocation().timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          "Location fetch timed out, falling back to cached coordinates".log();
          return LocationData.fromMap({});
        },
      );
    } catch (e) {
      e.log();
      return null;
    }
  }
}
