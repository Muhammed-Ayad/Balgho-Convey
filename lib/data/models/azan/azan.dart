import 'results.dart';

class Azan {
  final int code;
  final String status;
  final Results results;
  Azan({
    required this.code,
    required this.status,
    required this.results,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'status': status,
      'results': results.toMap(),
    };
  }

  factory Azan.fromJson(Map<String, dynamic> map) {
    return Azan(
      code: map['code']?.toInt() ?? 0,
      status: map['status'] ?? '',
      results: Results.fromJson(map["results"]),
    );
  }
}
