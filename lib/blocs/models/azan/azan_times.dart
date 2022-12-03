import 'package:json_annotation/json_annotation.dart';
part 'azan_times.g.dart';

@JsonSerializable()
class AzanTimes {
  final String imsak;
  final String sunrise;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String midnight;

  AzanTimes(this.imsak, this.sunrise, this.fajr, this.dhuhr, this.asr,
      this.sunset, this.maghrib, this.isha, this.midnight);

  factory AzanTimes.fromJson(Map<String, dynamic> json) =>
      _$AzanTimesFromJson(json);

  Map<String, dynamic> toJson() => _$AzanTimesToJson(this);
}
