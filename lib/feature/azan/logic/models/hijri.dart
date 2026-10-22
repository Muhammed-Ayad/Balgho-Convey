import 'package:great_quran/feature/azan/logic/models/designation.dart';
import 'package:great_quran/feature/azan/logic/models/month.dart';
import 'package:great_quran/feature/azan/logic/models/weekday.dart';

class Hijri {
  final String date;
  final String format;
  final String day;
  final Weekday weekday;
  final Month month;
  final String year;
  final Designation designation;

  const Hijri(
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
  );

  factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
        json['date'] as String? ?? '',
        json['format'] as String? ?? '',
        json['day'] as String? ?? '',
        Weekday.fromJson(json['weekday'] as Map<String, dynamic>? ?? {}),
        Month.fromJson(json['month'] as Map<String, dynamic>? ?? {}),
        json['year'] as String? ?? '',
        Designation.fromJson(
            json['designation'] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'format': format,
        'day': day,
        'weekday': weekday.toJson(),
        'month': month.toJson(),
        'year': year,
        'designation': designation.toJson(),
      };
}
