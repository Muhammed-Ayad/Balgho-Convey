import 'package:great_quran/feature/azan/logic/models/hijri.dart';
import 'package:json_annotation/json_annotation.dart';

part 'date.g.dart';

@JsonSerializable()
class Date {
  final String readable;
  final String timestamp;
  final Hijri hijri;

  Date(
    this.readable,
    this.timestamp,
    this.hijri,
  );

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);

  Map<String, dynamic> toJson() => _$DateToJson(this);
}
