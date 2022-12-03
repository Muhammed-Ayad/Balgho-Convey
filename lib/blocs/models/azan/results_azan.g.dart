// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results_azan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultsAzan _$ResultsAzanFromJson(Map<String, dynamic> json) => ResultsAzan(
      (json['datetime'] as List<dynamic>)
          .map((e) => DateTimeAzan.fromJson(e as Map<String, dynamic>))
          .toList(),
      LocationAzan.fromJson(json['location'] as Map<String, dynamic>),
      SettingsAzan.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultsAzanToJson(ResultsAzan instance) =>
    <String, dynamic>{
      'datetime': instance.datetime,
      'location': instance.location,
      'settings': instance.settings,
    };
