// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timings _$TimingsFromJson(Map<String, dynamic> json) => Timings(
      json['Fajr'] as String,
      json['Sunrise'] as String,
      json['Dhuhr'] as String,
      json['Asr'] as String,
      json['Sunset'] as String,
      json['Maghrib'] as String,
      json['Isha'] as String,
      json['Imsak'] as String,
      json['Midnight'] as String,
      json['Firstthird'] as String,
      json['Lastthird'] as String,
    );

Map<String, dynamic> _$TimingsToJson(Timings instance) => <String, dynamic>{
      'Fajr': instance.fajr,
      'Sunrise': instance.sunrise,
      'Dhuhr': instance.dhuhr,
      'Asr': instance.asr,
      'Sunset': instance.sunset,
      'Maghrib': instance.maghrib,
      'Isha': instance.isha,
      'Imsak': instance.imsak,
      'Midnight': instance.midnight,
      'Firstthird': instance.firstthird,
      'Lastthird': instance.lastthird,
    };
