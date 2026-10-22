class NotificationSettingsModel {
  final bool allNotificationsEnabled;

  final bool prayerNotificationsEnabled;
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;
  final bool prayerPreReminder;

  final bool azkarNotificationsEnabled;
  final bool morningAzkar;
  final bool eveningAzkar;
  final bool sleepAzkar;
  final bool wakeUpAzkar;

  final bool dailyZekrEnabled;
  final bool dailyHadithEnabled;

  final bool sunanEnabled;
  final bool duhaPrayer;
  final bool qiyamNight;

  final bool occasionsEnabled;
  final bool fridayKahf;
  final bool fastingMondayThursday;
  final bool fastingWhiteDays;

  const NotificationSettingsModel({
    this.allNotificationsEnabled = true,
    this.prayerNotificationsEnabled = true,
    this.fajr = true,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
    this.prayerPreReminder = true,
    this.azkarNotificationsEnabled = true,
    this.morningAzkar = true,
    this.eveningAzkar = true,
    this.sleepAzkar = true,
    this.wakeUpAzkar = false,
    this.dailyZekrEnabled = true,
    this.dailyHadithEnabled = true,
    this.sunanEnabled = true,
    this.duhaPrayer = true,
    this.qiyamNight = true,
    this.occasionsEnabled = true,
    this.fridayKahf = true,
    this.fastingMondayThursday = true,
    this.fastingWhiteDays = true,
  });

  NotificationSettingsModel copyWith({
    bool? allNotificationsEnabled,
    bool? prayerNotificationsEnabled,
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
    bool? prayerPreReminder,
    bool? azkarNotificationsEnabled,
    bool? morningAzkar,
    bool? eveningAzkar,
    bool? sleepAzkar,
    bool? wakeUpAzkar,
    bool? dailyZekrEnabled,
    bool? dailyHadithEnabled,
    bool? sunanEnabled,
    bool? duhaPrayer,
    bool? qiyamNight,
    bool? occasionsEnabled,
    bool? fridayKahf,
    bool? fastingMondayThursday,
    bool? fastingWhiteDays,
  }) {
    return NotificationSettingsModel(
      allNotificationsEnabled:
          allNotificationsEnabled ?? this.allNotificationsEnabled,
      prayerNotificationsEnabled:
          prayerNotificationsEnabled ?? this.prayerNotificationsEnabled,
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      prayerPreReminder: prayerPreReminder ?? this.prayerPreReminder,
      azkarNotificationsEnabled:
          azkarNotificationsEnabled ?? this.azkarNotificationsEnabled,
      morningAzkar: morningAzkar ?? this.morningAzkar,
      eveningAzkar: eveningAzkar ?? this.eveningAzkar,
      sleepAzkar: sleepAzkar ?? this.sleepAzkar,
      wakeUpAzkar: wakeUpAzkar ?? this.wakeUpAzkar,
      dailyZekrEnabled: dailyZekrEnabled ?? this.dailyZekrEnabled,
      dailyHadithEnabled: dailyHadithEnabled ?? this.dailyHadithEnabled,
      sunanEnabled: sunanEnabled ?? this.sunanEnabled,
      duhaPrayer: duhaPrayer ?? this.duhaPrayer,
      qiyamNight: qiyamNight ?? this.qiyamNight,
      occasionsEnabled: occasionsEnabled ?? this.occasionsEnabled,
      fridayKahf: fridayKahf ?? this.fridayKahf,
      fastingMondayThursday:
          fastingMondayThursday ?? this.fastingMondayThursday,
      fastingWhiteDays: fastingWhiteDays ?? this.fastingWhiteDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allNotificationsEnabled': allNotificationsEnabled,
      'prayerNotificationsEnabled': prayerNotificationsEnabled,
      'fajr': fajr,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
      'prayerPreReminder': prayerPreReminder,
      'azkarNotificationsEnabled': azkarNotificationsEnabled,
      'morningAzkar': morningAzkar,
      'eveningAzkar': eveningAzkar,
      'sleepAzkar': sleepAzkar,
      'wakeUpAzkar': wakeUpAzkar,
      'dailyZekrEnabled': dailyZekrEnabled,
      'dailyHadithEnabled': dailyHadithEnabled,
      'sunanEnabled': sunanEnabled,
      'duhaPrayer': duhaPrayer,
      'qiyamNight': qiyamNight,
      'occasionsEnabled': occasionsEnabled,
      'fridayKahf': fridayKahf,
      'fastingMondayThursday': fastingMondayThursday,
      'fastingWhiteDays': fastingWhiteDays,
    };
  }

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      allNotificationsEnabled: json['allNotificationsEnabled'] as bool? ?? true,
      prayerNotificationsEnabled:
          json['prayerNotificationsEnabled'] as bool? ?? true,
      fajr: json['fajr'] as bool? ?? true,
      dhuhr: json['dhuhr'] as bool? ?? true,
      asr: json['asr'] as bool? ?? true,
      maghrib: json['maghrib'] as bool? ?? true,
      isha: json['isha'] as bool? ?? true,
      prayerPreReminder: json['prayerPreReminder'] as bool? ?? true,
      azkarNotificationsEnabled:
          json['azkarNotificationsEnabled'] as bool? ?? true,
      morningAzkar: json['morningAzkar'] as bool? ?? true,
      eveningAzkar: json['eveningAzkar'] as bool? ?? true,
      sleepAzkar: json['sleepAzkar'] as bool? ?? true,
      wakeUpAzkar: json['wakeUpAzkar'] as bool? ?? false,
      dailyZekrEnabled: json['dailyZekrEnabled'] as bool? ?? true,
      dailyHadithEnabled: json['dailyHadithEnabled'] as bool? ?? true,
      sunanEnabled: json['sunanEnabled'] as bool? ?? true,
      duhaPrayer: json['duhaPrayer'] as bool? ?? true,
      qiyamNight: json['qiyamNight'] as bool? ?? true,
      occasionsEnabled: json['occasionsEnabled'] as bool? ?? true,
      fridayKahf: json['fridayKahf'] as bool? ?? true,
      fastingMondayThursday: json['fastingMondayThursday'] as bool? ?? true,
      fastingWhiteDays: json['fastingWhiteDays'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingsModel &&
          runtimeType == other.runtimeType &&
          allNotificationsEnabled == other.allNotificationsEnabled &&
          prayerNotificationsEnabled == other.prayerNotificationsEnabled &&
          fajr == other.fajr &&
          dhuhr == other.dhuhr &&
          asr == other.asr &&
          maghrib == other.maghrib &&
          isha == other.isha &&
          prayerPreReminder == other.prayerPreReminder &&
          azkarNotificationsEnabled == other.azkarNotificationsEnabled &&
          morningAzkar == other.morningAzkar &&
          eveningAzkar == other.eveningAzkar &&
          sleepAzkar == other.sleepAzkar &&
          wakeUpAzkar == other.wakeUpAzkar &&
          dailyZekrEnabled == other.dailyZekrEnabled &&
          dailyHadithEnabled == other.dailyHadithEnabled &&
          sunanEnabled == other.sunanEnabled &&
          duhaPrayer == other.duhaPrayer &&
          qiyamNight == other.qiyamNight &&
          occasionsEnabled == other.occasionsEnabled &&
          fridayKahf == other.fridayKahf &&
          fastingMondayThursday == other.fastingMondayThursday &&
          fastingWhiteDays == other.fastingWhiteDays;

  @override
  int get hashCode => Object.hashAll([
        allNotificationsEnabled,
        prayerNotificationsEnabled,
        fajr,
        dhuhr,
        asr,
        maghrib,
        isha,
        prayerPreReminder,
        azkarNotificationsEnabled,
        morningAzkar,
        eveningAzkar,
        sleepAzkar,
        wakeUpAzkar,
        dailyZekrEnabled,
        dailyHadithEnabled,
        sunanEnabled,
        duhaPrayer,
        qiyamNight,
        occasionsEnabled,
        fridayKahf,
        fastingMondayThursday,
        fastingWhiteDays,
      ]);
}
