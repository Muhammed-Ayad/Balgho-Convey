import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/data/remote/client/remote_client.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/data/remote/interfaces/i_azan_time_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'azan_api.g.dart';

@riverpod
AzanTimeApi azanTimeApi(AzanTimeApiRef ref) {
  return AzanTimeApi(
    ref.read(remoteClientProvider),
  );
}

class AzanTimeApi implements IAzanTimeApi {
  // * Dependencies
  final RemoteClient _remoteClient;
  AzanTimeApi(this._remoteClient);

  // *  Methods
  @override
  Future<Azan> getAzan() async {
    return Azan.fromJson(
      await _remoteClient.get(AppEndpoints.azanApi),
    );
  }
}
