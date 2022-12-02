import 'date_time_azan.dart';
import 'location_azan.dart';
import 'settings_azan.dart';
import 'package:json_annotation/json_annotation.dart';
part 'results_azan.g.dart';

@JsonSerializable()
class ResultsAzan {
  final List<DateTimeAzan> datetime;
  final LocationAzan location;
  final SettingsAzan settings;

  ResultsAzan(this.datetime, this.location, this.settings);

  factory ResultsAzan.fromJson(Map<String, dynamic> json) =>
      _$ResultsAzanFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsAzanToJson(this);
}
