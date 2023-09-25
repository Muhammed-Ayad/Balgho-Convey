import 'package:great_quran/blocs/models/azan/hijri.dart';
import 'package:great_quran/helpers/type_def.dart';
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

  factory Date.fromJson(JSON json) => _$DateFromJson(json);

  JSON toJson() => _$DateToJson(this);
}
