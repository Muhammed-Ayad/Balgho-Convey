import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'nawawi.g.dart';

@JsonSerializable()
class Nawawi {
  final String hadith;
  final String description;
  final String title;

  Nawawi(this.hadith, this.description, this.title);
  factory Nawawi.fromJson(JSON json) => _$NawawiFromJson(json);

  JSON toJson() => _$NawawiToJson(this);
}
