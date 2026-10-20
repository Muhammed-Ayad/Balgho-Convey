import 'package:json_annotation/json_annotation.dart';
part 'nawawi.g.dart';

@JsonSerializable()
class Nawawi {
  final String hadith;
  final String description;
  final String title;

  Nawawi(this.hadith, this.description, this.title);
  factory Nawawi.fromJson(Map<String, dynamic> json) => _$NawawiFromJson(json);

  Map<String, dynamic> toJson() => _$NawawiToJson(this);
}
