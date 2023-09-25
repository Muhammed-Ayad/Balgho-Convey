import 'package:great_quran/blocs/models/azan/azan.dart';
import 'package:great_quran/data/remote/apis/azan_api.dart';
import 'package:great_quran/data/remote/interfaces/i_azan_time_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'azan_time_provider.g.dart';

 
@riverpod
Future<Azan> azanTimeList(AzanTimeListRef ref) async {
  final IAzanTimeApi iAzanTimeApi = ref.watch(azanTimeApiProvider);
  return iAzanTimeApi.getAzan();
}
