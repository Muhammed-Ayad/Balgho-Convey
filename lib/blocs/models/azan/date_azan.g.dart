// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_azan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateAzan _$DateAzanFromJson(Map<String, dynamic> json) => DateAzan(
      json['timestamp'] as int,
      json['gregorian'] as String,
      json['hijri'] as String,
    );

Map<String, dynamic> _$DateAzanToJson(DateAzan instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'gregorian': instance.gregorian,
      'hijri': instance.hijri,
    };
