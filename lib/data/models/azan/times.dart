class Times {
  final String imsak;
  final String sunrise;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String midnight;
  Times({
    required this.imsak,
    required this.sunrise,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.midnight,
  });

  Map<String, dynamic> toMap() {
    return {
      'Imsak': imsak,
      'Sunrise': sunrise,
      'Fajr': fajr,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Sunset': sunset,
      'Maghrib': maghrib,
      'Isha': isha,
      'Midnight': midnight,
    };
  }

  factory Times.fromJson(Map<String, dynamic> map) {
    return Times(
      imsak: map['Imsak'] ?? '',
      sunrise: map['Sunrise'] ?? '',
      fajr: map['Fajr'] ?? '',
      dhuhr: map['Dhuhr'] ?? '',
      asr: map['Asr'] ?? '',
      sunset: map['Sunset'] ?? '',
      maghrib: map['Maghrib'] ?? '',
      isha: map['Isha'] ?? '',
      midnight: map['Midnight'] ?? '',
    );
  }
}
