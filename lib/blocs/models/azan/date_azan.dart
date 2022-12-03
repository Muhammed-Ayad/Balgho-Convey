import 'package:json_annotation/json_annotation.dart';
part 'date_azan.g.dart';

@JsonSerializable()
class DateAzan {
  final int timestamp;
  final String gregorian;
  final String hijri;

  DateAzan(this.timestamp, this.gregorian, this.hijri);

  factory DateAzan.fromJson(Map<String, dynamic> json) => _$DateAzanFromJson(json);

  Map<String, dynamic> toJson() => _$DateAzanToJson(this);
}
