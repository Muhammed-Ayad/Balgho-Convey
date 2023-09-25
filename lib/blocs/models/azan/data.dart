import 'package:great_quran/blocs/models/azan/date.dart';
import 'package:great_quran/blocs/models/azan/timings.dart';
import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

@JsonSerializable()
class Data {
  final Timings timings;
  final Date date;

  Data(
    this.timings,
    this.date,
  );
  factory Data.fromJson(JSON json) => _$DataFromJson(json);

  JSON toJson() => _$DataToJson(this);
}
