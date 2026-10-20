import 'package:json_annotation/json_annotation.dart';
part 'azkar.g.dart';

@JsonSerializable()
class Azkar {
  final String category;
  final String count;
  final String description;
  final String reference;
  final String zekr;

  Azkar(this.category, this.count, this.description, this.reference, this.zekr);
  factory Azkar.fromJson(Map<String, dynamic> json) => _$AzkarFromJson(json);

  Map<String, dynamic> toJson() => _$AzkarToJson(this);
}
