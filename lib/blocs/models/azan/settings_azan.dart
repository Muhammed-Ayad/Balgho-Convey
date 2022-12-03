import 'package:json_annotation/json_annotation.dart';
part 'settings_azan.g.dart';

@JsonSerializable()
class SettingsAzan {
  final String timeformat;
  final String school;
  final String juristic;
  final String highlat;
  final double fajrAngle;
  final double ishaAngle;

  SettingsAzan(this.timeformat, this.school, this.juristic, this.highlat,
      this.fajrAngle, this.ishaAngle);
  factory SettingsAzan.fromJson(Map<String, dynamic> json) =>
      _$SettingsAzanFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsAzanToJson(this);
}
