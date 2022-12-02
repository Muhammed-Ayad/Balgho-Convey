import 'package:json_annotation/json_annotation.dart';
part 'radios.g.dart';

@JsonSerializable()
class Radios {
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'URL')
  final String url;

  Radios(this.name, this.url);
  factory Radios.fromJson(Map<String, dynamic> json) => _$RadiosFromJson(json);

  Map<String, dynamic> toJson() => _$RadiosToJson(this);
}
