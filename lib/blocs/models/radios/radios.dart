import 'package:great_quran/blocs/models/radios/radio.dart';
import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'radios.g.dart';

@JsonSerializable()
class Radios {
  final String title;
  final List<RadioDetails> radio;

  Radios(this.title, this.radio);

  factory Radios.fromJson(JSON json) => _$RadiosFromJson(json);
  JSON toJson() => _$RadiosToJson(this);
}
