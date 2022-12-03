// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azan_date_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AzanDateTime _$AzanDateTimeFromJson(Map<String, dynamic> json) => AzanDateTime(
      AzanTimes.fromJson(json['times'] as Map<String, dynamic>),
      AzanDate.fromJson(json['date'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AzanDateTimeToJson(AzanDateTime instance) =>
    <String, dynamic>{
      'times': instance.times,
      'date': instance.date,
    };
