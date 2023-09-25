import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'timings.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Timings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;
  final String firstthird;
  final String lastthird;

  Timings(
      this.fajr,
      this.sunrise,
      this.dhuhr,
      this.asr,
      this.sunset,
      this.maghrib,
      this.isha,
      this.imsak,
      this.midnight,
      this.firstthird,
      this.lastthird);

  factory Timings.fromJson(JSON json) => _$TimingsFromJson(json);

  JSON toJson() => _$TimingsToJson(this);
}
