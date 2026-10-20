import 'package:great_quran/feature/azan/logic/models/designation.dart';
import 'package:great_quran/feature/azan/logic/models/month.dart';
import 'package:great_quran/feature/azan/logic/models/weekday.dart';
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

  factory Hijri.fromJson(Map<String, dynamic> json) => _$HijriFromJson(json);

  Map<String, dynamic> toJson() => _$HijriToJson(this);
}
