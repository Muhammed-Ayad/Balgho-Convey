import 'package:great_quran/core/network/endpoints.dart';
import 'package:great_quran/core/network/remote_client.dart';
import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class IAzanRepository {
  Future<Azan> getAzan();
}

class AzanRepository implements IAzanRepository {
  static final provider = Provider<IAzanRepository>(
    (ref) => AzanRepository(
      ref.read(RemoteClient.provider),
    ),
  );

  final RemoteClient _remoteClient;
  AzanRepository(this._remoteClient);

  @override
  Future<Azan> getAzan() async => Azan.fromJson(
        await _remoteClient.get(AppEndpoints.azanApi),
      );
}
