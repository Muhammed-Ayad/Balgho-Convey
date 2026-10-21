enum DaylightSavingMode {
  auto("تلقائي (حسب الهاتف)", "اعتماد توقيت الجهاز التلقائي"),
  winter("التوقيت الشتوي", "التوقيت القياسي الطبيعي"),
  summer("التوقيت الصيفي (+1 ساعة)", "إضافة ساعة واحدة لمواقيت الصلاة");

  final String title;
  final String description;

  const DaylightSavingMode(this.title, this.description);
}

enum AzanVoice {
  makkah("أذان الحرم المكي", "بصوت مؤذني المسجد الحرام",
      "https://raw.githubusercontent.com/abodehq/Athan-MP3/master/Sounds/Athan%20Makkah.mp3"),
  madinah("أذان المسجد النبوي - العفاسي", "أذان بصوت مشاري راشد العفاسي",
      "https://raw.githubusercontent.com/abodehq/Athan-MP3/master/Sounds/Athan%20Mishary%20Alafasi.mp3"),
  aqsa("أذان المسجد الأقصى - المنشاوي", "أذان بصوت الشيخ محمد صديق المنشاوي",
      "https://raw.githubusercontent.com/abodehq/Athan-MP3/master/Sounds/Athan%20Mohammad%20Almenshawy.mp3"),
  egypt("أذان القاهرة - الشيخ محمد رفعت", "الأذان التراثي الروحاني الخاشع",
      "https://raw.githubusercontent.com/abodehq/Athan-MP3/master/Sounds/Athan%20Mohammad%20Ref3at.mp3"),
  takbeerat("أذان الحرم - ناصر القطامي", "أذان بصوت الشيخ ناصر القطامي",
      "https://raw.githubusercontent.com/abodehq/Athan-MP3/master/Sounds/Athan%20Nasser%20Alqatami.mp3"),
  silent("إشعار نصي صامت", "إشعار بدون صوت الأذان", "");

  final String title;
  final String description;
  final String sampleUrl;

  const AzanVoice(this.title, this.description, this.sampleUrl);
}

class AzanNotificationPreferences {
  final bool isEnabled;
  final AzanVoice selectedVoice;
  final DaylightSavingMode daylightSavingMode;
  final int minuteAdjustment;
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;

  const AzanNotificationPreferences({
    this.isEnabled = true,
    this.selectedVoice = AzanVoice.makkah,
    this.daylightSavingMode = DaylightSavingMode.auto,
    this.minuteAdjustment = 0,
    this.fajr = true,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
  });

  AzanNotificationPreferences copyWith({
    bool? isEnabled,
    AzanVoice? selectedVoice,
    DaylightSavingMode? daylightSavingMode,
    int? minuteAdjustment,
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
  }) {
    return AzanNotificationPreferences(
      isEnabled: isEnabled ?? this.isEnabled,
      selectedVoice: selectedVoice ?? this.selectedVoice,
      daylightSavingMode: daylightSavingMode ?? this.daylightSavingMode,
      minuteAdjustment: minuteAdjustment ?? this.minuteAdjustment,
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }

  Map<String, dynamic> toJson() => {
        'isEnabled': isEnabled,
        'selectedVoice': selectedVoice.name,
        'daylightSavingMode': daylightSavingMode.name,
        'minuteAdjustment': minuteAdjustment,
        'fajr': fajr,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };

  factory AzanNotificationPreferences.fromJson(Map<String, dynamic> json) =>
      AzanNotificationPreferences(
        isEnabled: json['isEnabled'] as bool? ?? true,
        selectedVoice: AzanVoice.values.firstWhere(
          (v) => v.name == json['selectedVoice'],
          orElse: () => AzanVoice.makkah,
        ),
        daylightSavingMode: DaylightSavingMode.values.firstWhere(
          (v) => v.name == json['daylightSavingMode'],
          orElse: () => DaylightSavingMode.auto,
        ),
        minuteAdjustment: json['minuteAdjustment'] as int? ?? 0,
        fajr: json['fajr'] as bool? ?? true,
        dhuhr: json['dhuhr'] as bool? ?? true,
        asr: json['asr'] as bool? ?? true,
        maghrib: json['maghrib'] as bool? ?? true,
        isha: json['isha'] as bool? ?? true,
      );
}
