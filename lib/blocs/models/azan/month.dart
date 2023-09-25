import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'month.g.dart';

@JsonSerializable()
class Month {
  final int number;
  final String en;

  Month(this.number, this.en);
  factory Month.fromJson(JSON json) => _$MonthFromJson(json);

  JSON toJson() => _$MonthToJson(this);
}
