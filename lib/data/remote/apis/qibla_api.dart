import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/qibla/qibla_data.dart';
import 'package:great_quran/blocs/state_mix/state_mix.dart';
import 'package:great_quran/data/remote/client/remote_client.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/data/remote/interfaces/i_qibla_api.dart';
import 'package:great_quran/services/location_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'qibla_api.g.dart';

@riverpod
QiblaApi qiblaApi(QiblaApiRef ref) {
  return QiblaApi(
    ref.read(remoteClientProvider),
    ref.read(LocationService.provider),
  );
}

class QiblaApi implements IQiblaApi {
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
