class Timings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;
  final String firstthird;
  final String lastthird;

  const Timings(
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
  );

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        (json['Fajr'] ?? json['fajr'] ?? '') as String,
        (json['Sunrise'] ?? json['sunrise'] ?? '') as String,
        (json['Dhuhr'] ?? json['dhuhr'] ?? '') as String,
        (json['Asr'] ?? json['asr'] ?? '') as String,
        (json['Sunset'] ?? json['sunset'] ?? '') as String,
        (json['Maghrib'] ?? json['maghrib'] ?? '') as String,
        (json['Isha'] ?? json['isha'] ?? '') as String,
        (json['Imsak'] ?? json['imsak'] ?? '') as String,
        (json['Midnight'] ?? json['midnight'] ?? '') as String,
        (json['Firstthird'] ?? json['firstthird'] ?? '') as String,
        (json['Lastthird'] ?? json['lastthird'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Sunset': sunset,
        'Maghrib': maghrib,
        'Isha': isha,
        'Imsak': imsak,
        'Midnight': midnight,
        'Firstthird': firstthird,
        'Lastthird': lastthird,
      };
}
