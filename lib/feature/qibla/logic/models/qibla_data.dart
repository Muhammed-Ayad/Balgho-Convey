import 'package:json_annotation/json_annotation.dart';
part "qibla_data.g.dart";

@JsonSerializable()
class QiblaData {
  final double latitude;
  final double longitude;
  final double direction;

  QiblaData(this.latitude, this.longitude, this.direction);

  factory QiblaData.fromJson(Map<String, dynamic> json) =>
      _$QiblaDataFromJson(json);

  Map<String, dynamic> toJson() => _$QiblaDataToJson(this);
}
