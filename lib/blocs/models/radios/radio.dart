import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'radio.g.dart';

@JsonSerializable()
class RadioDetails {
  final String name;
  final String url;

  RadioDetails(this.name, this.url);

  factory RadioDetails.fromJson(JSON json) => _$RadioDetailsFromJson(json);
  JSON toJson() => _$RadioDetailsToJson(this);
}
