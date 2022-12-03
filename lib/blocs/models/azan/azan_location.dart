import 'package:json_annotation/json_annotation.dart';
part 'azan_location.g.dart';

@JsonSerializable()
class AzanLocation {
  final double latitude;
  final double longitude;
  final double elevation;
  final String city;
  final String country;
  final String countryCode;
  final String timezone;
  final double localOffset;

  AzanLocation(this.latitude, this.longitude, this.elevation, this.city,
      this.country, this.countryCode, this.timezone, this.localOffset);
  factory AzanLocation.fromJson(Map<String, dynamic> json) =>
      _$AzanLocationFromJson(json);

  Map<String, dynamic> toJson() => _$AzanLocationToJson(this);
}
