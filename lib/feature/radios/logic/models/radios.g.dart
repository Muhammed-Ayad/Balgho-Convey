// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radios.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Radios _$RadiosFromJson(Map<String, dynamic> json) => Radios(
      json['title'] as String,
      (json['radio'] as List<dynamic>)
          .map((e) => RadioDetalis.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RadiosToJson(Radios instance) => <String, dynamic>{
      'title': instance.title,
      'radio': instance.radio,
    };
