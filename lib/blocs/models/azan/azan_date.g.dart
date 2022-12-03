// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azan_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AzanDate _$AzanDateFromJson(Map<String, dynamic> json) => AzanDate(
      json['timestamp'] as int,
      json['gregorian'] as String,
      json['hijri'] as String,
    );

Map<String, dynamic> _$AzanDateToJson(AzanDate instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'gregorian': instance.gregorian,
      'hijri': instance.hijri,
    };
