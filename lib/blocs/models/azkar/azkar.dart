import 'package:great_quran/helpers/type_def.dart';
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
  factory Azkar.fromJson(JSON json) => _$AzkarFromJson(json);

  JSON toJson() => _$AzkarToJson(this);
}
