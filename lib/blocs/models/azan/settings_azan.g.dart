// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_azan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsAzan _$SettingsAzanFromJson(Map<String, dynamic> json) => SettingsAzan(
      json['timeformat'] as String,
      json['school'] as String,
      json['juristic'] as String,
      json['highlat'] as String,
      (json['fajrAngle'] as num).toDouble(),
      (json['ishaAngle'] as num).toDouble(),
    );

Map<String, dynamic> _$SettingsAzanToJson(SettingsAzan instance) =>
    <String, dynamic>{
      'timeformat': instance.timeformat,
      'school': instance.school,
      'juristic': instance.juristic,
      'highlat': instance.highlat,
      'fajrAngle': instance.fajrAngle,
      'ishaAngle': instance.ishaAngle,
    };
