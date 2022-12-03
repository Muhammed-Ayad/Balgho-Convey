import 'azan_date.dart';
import 'azan_times.dart';
import 'package:json_annotation/json_annotation.dart';
part 'azan_date_time.g.dart';

@JsonSerializable()
class AzanDateTime {
  final AzanTimes times;
  final AzanDate date;

  AzanDateTime(this.times, this.date);
  factory AzanDateTime.fromJson(Map<String, dynamic> json) =>
      _$AzanDateTimeFromJson(json);

  Map<String, dynamic> toJson() => _$AzanDateTimeToJson(this);
}
