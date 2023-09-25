import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'weekday.g.dart';

@JsonSerializable()
class Weekday {
  final String en;
  final String ar;

  Weekday(this.en, this.ar);

  factory Weekday.fromJson(JSON json) => _$WeekdayFromJson(json);

  JSON toJson() => _$WeekdayToJson(this);
}
