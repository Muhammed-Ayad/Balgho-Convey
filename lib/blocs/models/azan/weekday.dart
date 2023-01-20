import 'package:json_annotation/json_annotation.dart';
part 'weekday.g.dart';

@JsonSerializable()
class Weekday {
  final String en;
  final String ar;

  Weekday(this.en, this.ar);

  factory Weekday.fromJson(Map<String, dynamic> json) =>
      _$WeekdayFromJson(json);

  Map<String, dynamic> toJson() => _$WeekdayToJson(this);
}
