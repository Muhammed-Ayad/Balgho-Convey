import 'date_azan.dart';
import 'times_azan.dart';
import 'package:json_annotation/json_annotation.dart';
part 'date_time_azan.g.dart';

@JsonSerializable()
class DateTimeAzan {
  final TimesAzan times;
  final DateAzan date;

  DateTimeAzan(this.times, this.date);
  factory DateTimeAzan.fromJson(Map<String, dynamic> json) =>
      _$DateTimeAzanFromJson(json);

  Map<String, dynamic> toJson() => _$DateTimeAzanToJson(this);
}
