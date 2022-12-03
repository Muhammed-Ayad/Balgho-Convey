// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azan_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AzanSettings _$AzanSettingsFromJson(Map<String, dynamic> json) => AzanSettings(
      json['timeformat'] as String,
      json['school'] as String,
      json['juristic'] as String,
      json['highlat'] as String,
      (json['fajrAngle'] as num).toDouble(),
      (json['ishaAngle'] as num).toDouble(),
    );

Map<String, dynamic> _$AzanSettingsToJson(AzanSettings instance) =>
    <String, dynamic>{
      'timeformat': instance.timeformat,
      'school': instance.school,
      'juristic': instance.juristic,
      'highlat': instance.highlat,
      'fajrAngle': instance.fajrAngle,
      'ishaAngle': instance.ishaAngle,
    };
