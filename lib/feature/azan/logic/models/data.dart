import 'package:great_quran/feature/azan/logic/models/date.dart';
import 'package:great_quran/feature/azan/logic/models/timings.dart';

class Data {
  final Timings timings;
  final Date date;

  const Data(
    this.timings,
    this.date,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        Timings.fromJson(json['timings'] as Map<String, dynamic>? ?? {}),
        Date.fromJson(json['date'] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'timings': timings.toJson(),
        'date': date.toJson(),
      };
}
