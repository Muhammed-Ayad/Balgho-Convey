import 'azan_date_time.dart';
import 'azan_location.dart';
import 'azan_settings.dart';
import 'package:json_annotation/json_annotation.dart';
part 'azan_results.g.dart';

@JsonSerializable()
class AzanResults {
  final List<AzanDateTime> datetime;
  final AzanLocation location;
  final AzanSettings settings;

  AzanResults(this.datetime, this.location, this.settings);

  factory AzanResults.fromJson(Map<String, dynamic> json) =>
      _$AzanResultsFromJson(json);

  Map<String, dynamic> toJson() => _$AzanResultsToJson(this);
}
