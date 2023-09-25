import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'designation.g.dart';

@JsonSerializable()
class Designation {
  final String abbreviated;
  final String expanded;

  Designation(this.abbreviated, this.expanded);

  factory Designation.fromJson(JSON json) => _$DesignationFromJson(json);

  JSON toJson() => _$DesignationToJson(this);
}
