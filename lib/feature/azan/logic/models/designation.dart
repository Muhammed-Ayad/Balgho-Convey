import 'package:json_annotation/json_annotation.dart';
part 'designation.g.dart';

@JsonSerializable()
class Designation {
  final String abbreviated;
  final String expanded;

  Designation(this.abbreviated, this.expanded);

  factory Designation.fromJson(Map<String, dynamic> json) =>
      _$DesignationFromJson(json);

  Map<String, dynamic> toJson() => _$DesignationToJson(this);
}
