// Copyright (c) 2023 by Salama Enigma (salama92work@gmail.com)
// All rights reserved.
// Check out my Github account (https://github.com/salamaEnigma) for more projects.

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/state_mix/state_mix.dart';
import 'package:location/location.dart';

class LocationService {
  static final provider = Provider<LocationService>(
    (ref) => LocationService(),
  );

  final location = Location();
  Future<LocationData?> getCurrentLocation() async {
    try {
      // Check location service availability
      final isServiceAvailable = await checkLocationServiceAvailability();

      if (isServiceAvailable) {
        return await location.getLocation();
      }
    } catch (e) {
      e.log();
    }
    return null;
  }

  // Check if location service is enabled & permission status is granted
  Future<bool> checkLocationServiceAvailability() async {
    // Service Flags
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    if (!kIsWeb) {
      // Check location service availability
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location service is not enabled");
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      // Check location permission status
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
