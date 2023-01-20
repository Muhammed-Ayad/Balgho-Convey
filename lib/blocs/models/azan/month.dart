import 'package:json_annotation/json_annotation.dart';
part 'month.g.dart';

@JsonSerializable()
class Month {
  final int number;
  final String en;

  Month(this.number, this.en);
  factory Month.fromJson(Map<String, dynamic> json) => _$MonthFromJson(json);

  Map<String, dynamic> toJson() => _$MonthToJson(this);
}
