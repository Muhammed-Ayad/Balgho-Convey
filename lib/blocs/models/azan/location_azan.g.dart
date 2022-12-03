// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_azan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationAzan _$LocationAzanFromJson(Map<String, dynamic> json) => LocationAzan(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      (json['elevation'] as num).toDouble(),
      json['city'] as String,
      json['country'] as String,
      json['countryCode'] as String,
      json['timezone'] as String,
      (json['localOffset'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationAzanToJson(LocationAzan instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'elevation': instance.elevation,
      'city': instance.city,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'timezone': instance.timezone,
      'localOffset': instance.localOffset,
    };
