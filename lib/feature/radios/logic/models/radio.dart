import 'package:json_annotation/json_annotation.dart';
part 'radio.g.dart';

@JsonSerializable()
class RadioDetalis {
  final String name;
  final String url;

  RadioDetalis(this.name, this.url);

  factory RadioDetalis.fromJson(Map<String, dynamic> json) =>
      _$RadioDetalisFromJson(json);
  Map<String, dynamic> toJson() => _$RadioDetalisToJson(this);
}
