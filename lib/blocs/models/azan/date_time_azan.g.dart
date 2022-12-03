// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_time_azan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateTimeAzan _$DateTimeAzanFromJson(Map<String, dynamic> json) => DateTimeAzan(
      TimesAzan.fromJson(json['times'] as Map<String, dynamic>),
      DateAzan.fromJson(json['date'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DateTimeAzanToJson(DateTimeAzan instance) =>
    <String, dynamic>{
      'times': instance.times,
      'date': instance.date,
    };
