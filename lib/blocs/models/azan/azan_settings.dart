import 'package:json_annotation/json_annotation.dart';
part 'azan_settings.g.dart';

@JsonSerializable()
class AzanSettings {
  final String timeformat;
  final String school;
  final String juristic;
  final String highlat;
  final double fajrAngle;
  final double ishaAngle;

  AzanSettings(this.timeformat, this.school, this.juristic, this.highlat,
      this.fajrAngle, this.ishaAngle);
  factory AzanSettings.fromJson(Map<String, dynamic> json) =>
      _$AzanSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AzanSettingsToJson(this);
}
