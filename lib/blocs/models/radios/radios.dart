import 'package:great_quran/blocs/models/radios/radio.dart';
import 'package:json_annotation/json_annotation.dart';
part 'radios.g.dart';

@JsonSerializable()
class Radios {
  final String title;
  final List<RadioDetalis> radio;

  Radios(this.title, this.radio);

  factory Radios.fromJson(Map<String, dynamic> json) => _$RadiosFromJson(json);
  Map<String, dynamic> toJson() => _$RadiosToJson(this);
}
