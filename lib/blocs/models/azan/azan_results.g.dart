// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azan_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AzanResults _$AzanResultsFromJson(Map<String, dynamic> json) => AzanResults(
      (json['datetime'] as List<dynamic>)
          .map((e) => AzanDateTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      AzanLocation.fromJson(json['location'] as Map<String, dynamic>),
      AzanSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AzanResultsToJson(AzanResults instance) =>
    <String, dynamic>{
      'datetime': instance.datetime,
      'location': instance.location,
      'settings': instance.settings,
    };
