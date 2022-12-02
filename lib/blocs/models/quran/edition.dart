import 'package:json_annotation/json_annotation.dart';
part 'edition.g.dart';

@JsonSerializable()
class Edition {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;

  Edition(this.identifier, this.language, this.name, this.englishName,
      this.format, this.type);

  factory Edition.fromJson(Map<String, dynamic> json) =>
      _$EditionFromJson(json);

  Map<String, dynamic> toJson() => _$EditionToJson(this);
}
