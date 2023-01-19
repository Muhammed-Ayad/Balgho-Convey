// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timings _$TimingsFromJson(Map<String, dynamic> json) => Timings(
      json['fajr'] as String,
      json['sunrise'] as String,
      json['dhuhr'] as String,
      json['asr'] as String,
      json['sunset'] as String,
      json['maghrib'] as String,
      json['isha'] as String,
      json['imsak'] as String,
      json['midnight'] as String,
      json['firstthird'] as String,
      json['lastthird'] as String,
    );

Map<String, dynamic> _$TimingsToJson(Timings instance) => <String, dynamic>{
      'fajr': instance.fajr,
      'sunrise': instance.sunrise,
      'dhuhr': instance.dhuhr,
      'asr': instance.asr,
      'sunset': instance.sunset,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
      'imsak': instance.imsak,
      'midnight': instance.midnight,
      'firstthird': instance.firstthird,
      'lastthird': instance.lastthird,
    };
