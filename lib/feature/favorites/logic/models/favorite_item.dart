import 'package:json_annotation/json_annotation.dart';

part 'favorite_item.g.dart';

enum FavoriteType {
  @JsonValue('zekr')
  zekr,
  @JsonValue('radio')
  radio,
}

@JsonSerializable()
class FavoriteItem {
  final String id;
  final String title;
  final String content;
  final String extraData;
  final FavoriteType type;
  final DateTime createdAt;

  const FavoriteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.extraData,
    required this.type,
    required this.createdAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemToJson(this);
}
