import 'package:json_annotation/json_annotation.dart';
part 'times_azan.g.dart';

@JsonSerializable()
class TimesAzan {
  final String imsak;
  final String sunrise;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String midnight;

  TimesAzan(this.imsak, this.sunrise, this.fajr, this.dhuhr, this.asr,
      this.sunset, this.maghrib, this.isha, this.midnight);

  factory TimesAzan.fromJson(Map<String, dynamic> json) =>
      _$TimesAzanFromJson(json);

  Map<String, dynamic> toJson() => _$TimesAzanToJson(this);
}
