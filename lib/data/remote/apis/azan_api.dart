import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/data/remote/client/remote_client.dart';
import 'package:great_quran/data/remote/endpoints.dart';
import 'package:great_quran/data/remote/interfaces/i_azan_time_api.dart';

class AzanTimeApi implements IAzanTimeApi {
  static final provider = Provider<IAzanTimeApi>(
    (ref) => AzanTimeApi(
      ref.read(RemoteClient.provider),
    ),
  );

  // * Dependencies
  final RemoteClient _remoteClient;
  AzanTimeApi(this._remoteClient);

  // *  Methods
  @override
  Future<Azan> getAzan() async {
    final url = AppEndpoints.url;
   
      
      final response = await _remoteClient.get(url);
      log(response);
      return Azan.fromJson(response as Map<String, dynamic>);
    
  }
}
