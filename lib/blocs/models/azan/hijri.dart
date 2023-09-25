import 'package:great_quran/blocs/models/azan/designation.dart';
import 'package:great_quran/blocs/models/azan/month.dart';
import 'package:great_quran/blocs/models/azan/weekday.dart';
import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'hijri.g.dart';

@JsonSerializable()
class Hijri {
  final String date;
  final String format;
  final String day;
  final Weekday weekday;
  final Month month;
  final String year;
  final Designation designation;

  Hijri(
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
  );

  factory Hijri.fromJson(JSON json) => _$HijriFromJson(json);

  JSON toJson() => _$HijriToJson(this);
}
