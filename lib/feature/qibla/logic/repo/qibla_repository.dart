import 'package:great_quran/core/network/endpoints.dart';
import 'package:great_quran/core/network/remote_client.dart';
import 'package:great_quran/core/services/location_service.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/feature/qibla/logic/models/qibla_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class IQiblaRepository {
  Future<double> getQiblaDirection();
}

class QiblaRepository implements IQiblaRepository {
  static final provider = Provider<IQiblaRepository>(
    (ref) => QiblaRepository(
      ref.read(RemoteClient.provider),
      ref.read(LocationService.provider),
    ),
  );

  final RemoteClient _remoteClient;
  final LocationService _locationService;
  QiblaRepository(this._remoteClient, this._locationService);

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
