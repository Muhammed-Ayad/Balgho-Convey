import 'package:json_annotation/json_annotation.dart';
part 'location_azan.g.dart';

@JsonSerializable()
class LocationAzan {
  final double latitude;
  final double longitude;
  final double elevation;
  final String city;
  final String country;
  final String countryCode;
  final String timezone;
  final double localOffset;

  LocationAzan(this.latitude, this.longitude, this.elevation, this.city,
      this.country, this.countryCode, this.timezone, this.localOffset);
  factory LocationAzan.fromJson(Map<String, dynamic> json) =>
      _$LocationAzanFromJson(json);

  Map<String, dynamic> toJson() => _$LocationAzanToJson(this);
}
