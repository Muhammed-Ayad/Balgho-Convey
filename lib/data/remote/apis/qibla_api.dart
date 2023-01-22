import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/state_mix/_index.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/data/remote/interfaces/i_qibla_api.dart';
import 'package:great_quran/services/location_service.dart';

import '../../../blocs/models/qibla/qibla_data.dart';
import '../client/remote_client.dart';

class QiblaApi implements IQiblaApi {
  static final provider = Provider<IQiblaApi>(
    (ref) => QiblaApi(
      ref.read(RemoteClient.provider),
      ref.read(LocationService.provider),
    ),
  );

  // * Dependencies
  final RemoteClient _remoteClient;
  final LocationService _locationService;
  QiblaApi(this._remoteClient, this._locationService);

  // *  Methods
  @override
  Future<double> getQiblaDirection() async {
    final locationData = await _locationService.getCurrentLocation();
    if (locationData != null) {
      final response = await _remoteClient.get(AppEndpoints.qiblaApi(
          locationData.latitude!, locationData.longitude!));
      final direction = QiblaData.fromJson(response["data"]).direction;
      "Qibla Direction in degrees from N $direction".log();
      return direction;
    } else {
      throw "تأكد من تشغيل خدمة الموقع و إعطاء الإذن للتطبيق";
    }
  }
}
