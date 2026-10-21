part of 'favorite_item.dart';

FavoriteItem _$FavoriteItemFromJson(Map<String, dynamic> json) => FavoriteItem(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      extraData: json['extraData'] as String? ?? '',
      type: $enumDecode(_$FavoriteTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FavoriteItemToJson(FavoriteItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'extraData': instance.extraData,
      'type': _$FavoriteTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FavoriteTypeEnumMap = {
  FavoriteType.zekr: 'zekr',
  FavoriteType.radio: 'radio',
};
