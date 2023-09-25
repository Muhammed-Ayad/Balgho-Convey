import 'package:great_quran/blocs/models/azan/data.dart';
import 'package:great_quran/helpers/type_def.dart';
import 'package:json_annotation/json_annotation.dart';
part 'azan.g.dart';

@JsonSerializable()
class Azan {
  final int code;
  final String status;
  final Data data;

  Azan(this.code, this.status, this.data);

  factory Azan.fromJson(JSON json) => _$AzanFromJson(json);

  JSON toJson() => _$AzanToJson(this);
}
