// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Azan _$AzanFromJson(Map<String, dynamic> json) => Azan(
      json['code'] as int,
      json['status'] as String,
      ResultsAzan.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AzanToJson(Azan instance) => <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'results': instance.results,
    };
