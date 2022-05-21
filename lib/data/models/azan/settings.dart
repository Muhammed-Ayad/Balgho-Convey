class Settings {
  final String timeformat;
  final String school;
  final String juristic;
  final String highlat;
  final double fajrAngle;
  final double ishaAngle;
  Settings({
    required this.timeformat,
    required this.school,
    required this.juristic,
    required this.highlat,
    required this.fajrAngle,
    required this.ishaAngle,
  });

  Map<String, dynamic> toMap() {
    return {
      'timeformat': timeformat,
      'school': school,
      'juristic': juristic,
      'highlat': highlat,
      'fajr_angle': fajrAngle,
      'isha_angle': ishaAngle,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> map) {
    return Settings(
      timeformat: map['timeformat'] ?? '',
      school: map['school'] ?? '',
      juristic: map['juristic'] ?? '',
      highlat: map['highlat'] ?? '',
      fajrAngle: map['fajr_angle']?.toDouble() ?? 0.0,
      ishaAngle: map['isha_angle']?.toDouble() ?? 0.0,
    );
  }
}
