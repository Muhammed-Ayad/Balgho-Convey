import 'package:great_quran/feature/azan/logic/models/hijri.dart';

class Date {
  final String readable;
  final String timestamp;
  final Hijri hijri;

  const Date(
    this.readable,
    this.timestamp,
    this.hijri,
  );

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        json['readable'] as String? ?? '',
        json['timestamp'] as String? ?? '',
        Hijri.fromJson(json['hijri'] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'readable': readable,
        'timestamp': timestamp,
        'hijri': hijri.toJson(),
      };
}
