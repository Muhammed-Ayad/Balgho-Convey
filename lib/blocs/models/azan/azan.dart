//* ========================================
import 'package:great_quran/blocs/models/azan/data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'azan.g.dart';

@JsonSerializable()
class Azan {
  final int code;
  final String status;
  final Data data;

  Azan(this.code, this.status, this.data);

  factory Azan.fromJson(Map<String, dynamic> json) => _$AzanFromJson(json);

  Map<String, dynamic> toJson() => _$AzanToJson(this);
}
