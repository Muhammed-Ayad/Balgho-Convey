import 'results_azan.dart';
import 'package:json_annotation/json_annotation.dart';
part 'azan.g.dart';

@JsonSerializable()
class Azan {
  final int code;
  final String status;
  final ResultsAzan results;

  Azan(this.code, this.status, this.results);

  factory Azan.fromJson(Map<String, dynamic> json) => _$AzanFromJson(json);

  Map<String, dynamic> toJson() => _$AzanToJson(this);
}
