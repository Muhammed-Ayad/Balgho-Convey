import 'package:great_quran/feature/azan/logic/models/data.dart';

class Azan {
  final int code;
  final String status;
  final Data data;

  const Azan(this.code, this.status, this.data);

  factory Azan.fromJson(Map<String, dynamic> json) => Azan(
        (json['code'] as num?)?.toInt() ?? 0,
        json['status'] as String? ?? '',
        Data.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'data': data.toJson(),
      };
}
