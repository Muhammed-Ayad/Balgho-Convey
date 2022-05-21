import 'date.dart';
import 'times.dart';

class Datetime {
  final Times times;
  final Date date;
  Datetime({
    required this.times,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'times': times.toMap(),
      'date': date.toMap(),
    };
  }

  factory Datetime.fromJson(Map<String, dynamic> map) {
    return Datetime(
      times: Times.fromJson(map["times"]),
      date: Date.fromJson(map["date"]),
    );
  }
}
