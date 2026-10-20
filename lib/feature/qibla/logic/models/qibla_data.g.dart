// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qibla_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QiblaData _$QiblaDataFromJson(Map<String, dynamic> json) => QiblaData(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      (json['direction'] as num).toDouble(),
    );

Map<String, dynamic> _$QiblaDataToJson(QiblaData instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'direction': instance.direction,
    };
