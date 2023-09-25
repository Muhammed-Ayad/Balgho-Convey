import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part "qibla_data.g.dart";

@JsonSerializable()
class QiblaData {
  final double latitude;
  final double longitude;
  final double direction;

  QiblaData(this.latitude, this.longitude, this.direction);

  factory QiblaData.fromJson(JSON json) => _$QiblaDataFromJson(json);

  JSON toJson() => _$QiblaDataToJson(this);
}
