import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/remote/endpoints.dart';
import '../../../data/models/azan/azan.dart';
import 'package:http/http.dart' as http;
part 'azan_time_state.dart';

class AzanTimeCubit extends Cubit<AzanTimeState> {
  AzanTimeCubit() : super(AzanTimeInitial());

  Future<Azan> getAzan() async {
    final response = await http.get(Uri.parse(AppEndpoints.url));
    final jsonResponse = json.decode(response.body);
    return Azan.fromJson(jsonResponse);
  }
}
