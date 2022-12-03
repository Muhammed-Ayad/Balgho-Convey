// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azan_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AzanTimes _$AzanTimesFromJson(Map<String, dynamic> json) => AzanTimes(
      json['imsak'] as String,
      json['sunrise'] as String,
      json['fajr'] as String,
      json['dhuhr'] as String,
      json['asr'] as String,
      json['sunset'] as String,
      json['maghrib'] as String,
      json['isha'] as String,
      json['midnight'] as String,
    );

Map<String, dynamic> _$AzanTimesToJson(AzanTimes instance) => <String, dynamic>{
      'imsak': instance.imsak,
      'sunrise': instance.sunrise,
      'fajr': instance.fajr,
      'dhuhr': instance.dhuhr,
      'asr': instance.asr,
      'sunset': instance.sunset,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
      'midnight': instance.midnight,
    };
