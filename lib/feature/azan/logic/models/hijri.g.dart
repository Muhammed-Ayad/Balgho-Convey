// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hijri.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hijri _$HijriFromJson(Map<String, dynamic> json) => Hijri(
      json['date'] as String,
      json['format'] as String,
      json['day'] as String,
      Weekday.fromJson(json['weekday'] as Map<String, dynamic>),
      Month.fromJson(json['month'] as Map<String, dynamic>),
      json['year'] as String,
      Designation.fromJson(json['designation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HijriToJson(Hijri instance) => <String, dynamic>{
      'date': instance.date,
      'format': instance.format,
      'day': instance.day,
      'weekday': instance.weekday,
      'month': instance.month,
      'year': instance.year,
      'designation': instance.designation,
    };
