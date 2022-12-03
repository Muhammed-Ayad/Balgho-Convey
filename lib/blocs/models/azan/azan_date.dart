import 'package:json_annotation/json_annotation.dart';
part 'azan_date.g.dart';

@JsonSerializable()
class AzanDate {
  final int timestamp;
  final String gregorian;
  final String hijri;

  AzanDate(this.timestamp, this.gregorian, this.hijri);

  factory AzanDate.fromJson(Map<String, dynamic> json) =>
      _$AzanDateFromJson(json);

  Map<String, dynamic> toJson() => _$AzanDateToJson(this);
}
