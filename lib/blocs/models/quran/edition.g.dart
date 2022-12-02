// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Edition _$EditionFromJson(Map<String, dynamic> json) => Edition(
      json['identifier'] as String,
      json['language'] as String,
      json['name'] as String,
      json['englishName'] as String,
      json['format'] as String,
      json['type'] as String,
    );

Map<String, dynamic> _$EditionToJson(Edition instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'language': instance.language,
      'name': instance.name,
      'englishName': instance.englishName,
      'format': instance.format,
      'type': instance.type,
    };
