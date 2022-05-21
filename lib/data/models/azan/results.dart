import 'datetime.dart';
import 'location.dart';
import 'settings.dart';

class Results {
  final List<Datetime> datetime;
  final Location location;
  final Settings settings;
  Results({
    required this.datetime,
    required this.location,
    required this.settings,
  });


  Map<String, dynamic> toMap() {
    return {
      'datetime': datetime.map((x) => x.toMap()).toList(),
      'location': location.toMap(),
      'settings': settings.toMap(),
    };
  }

  factory Results.fromJson(Map<String, dynamic> map) {
    return Results(
      datetime: List<Datetime>.from(
          map["datetime"].map((it) => Datetime.fromJson(it))),
      location: Location.fromJson(map["location"]),
      settings: Settings.fromJson(map["settings"]),
    );
  }
}
