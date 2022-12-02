// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ayah _$AyahFromJson(Map<String, dynamic> json) => Ayah(
      json['number'] as int,
      json['text'] as String,
      json['numberInSurah'] as int,
      json['juz'] as int,
      json['manzil'] as int,
      json['page'] as int,
      json['ruku'] as int,
      json['hizbQuarter'] as int,
    );

Map<String, dynamic> _$AyahToJson(Ayah instance) => <String, dynamic>{
      'number': instance.number,
      'text': instance.text,
      'numberInSurah': instance.numberInSurah,
      'juz': instance.juz,
      'manzil': instance.manzil,
      'page': instance.page,
      'ruku': instance.ruku,
      'hizbQuarter': instance.hizbQuarter,
    };
