import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:great_quran/core/services/local_notification_service.dart';
import 'package:great_quran/feature/azan/logic/repo/azan_repository.dart';
import 'package:great_quran/feature/notifications/logic/models/notification_settings_model.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/repo/azan_settings_repository.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSchedulerService {
  static final provider = Provider<NotificationSchedulerService>((ref) {
    return NotificationSchedulerService(
      ref.read(LocalNotificationService.provider),
      ref.read(AzanRepository.provider),
      ref.read(AzanSettingsRepository.provider),
    );
  });

  final LocalNotificationService _notificationService;
  final IAzanRepository _azanRepository;
  final IAzanSettingsRepository _azanSettingsRepository;

  NotificationSchedulerService(
    this._notificationService,
    this._azanRepository,
    this._azanSettingsRepository,
  );

  static const int idFajr = 101;
  static const int idDhuhr = 102;
  static const int idAsr = 103;
  static const int idMaghrib = 104;
  static const int idIsha = 105;

  static const int idFajrPre = 111;
  static const int idDhuhrPre = 112;
  static const int idAsrPre = 113;
  static const int idMaghribPre = 114;
  static const int idIshaPre = 115;

  static const int idMorningAzkar = 201;
  static const int idEveningAzkar = 202;
  static const int idSleepAzkar = 203;
  static const int idWakeUpAzkar = 204;

  static const int idDailyZekr = 301;
  static const int idDailyHadith = 302;

  static const int idDuha = 401;
  static const int idQiyam = 402;

  static const int idFridayKahf = 501;
  static const int idFastingMonday = 502;
  static const int idFastingThursday = 503;
  static const int idFastingWhiteDays = 504;

  static const int idTestNotification = 999;

  /// Number of days to schedule in advance. A rolling 7-day schedule
  /// ensures exact times without relying on buggy native daily repeats.
  static const int daysToSchedule = 7;
  static const int dayOffsetMultiplier = 10000;

  Future<void> sendTestNotification() async {
    debugPrint("NotificationSchedulerService: sendTestNotification() invoked.");
    AzanNotificationPreferences azanPrefs;
    try {
      azanPrefs = await _azanSettingsRepository.getPreferences();
    } catch (_) {
      azanPrefs = const AzanNotificationPreferences();
    }

    await _notificationService.showInstantNotification(
      id: idTestNotification,
      title: "تطبيق بلغوا 🌿 (تجربة صوت الأذان)",
      body:
          "حان الآن موعد الصلاة.. صوت المؤذن المختار: ${azanPrefs.selectedVoice.title}",
      payload: "test",
      notificationDetails: LocalNotificationService.getAzanNotificationDetails(
          azanPrefs.selectedVoice),
    );
  }

  Future<bool> scheduleTestNotification({int seconds = 15}) async {
    debugPrint(
        "NotificationSchedulerService: scheduleTestNotification($seconds s) invoked.");
    AzanNotificationPreferences azanPrefs;
    try {
      azanPrefs = await _azanSettingsRepository.getPreferences();
    } catch (_) {
      azanPrefs = const AzanNotificationPreferences();
    }

    final canExact = await _notificationService.canScheduleExactNotifications();
    final scheduledTime = DateTime.now().add(Duration(seconds: seconds));
    await _notificationService.scheduleNotification(
      id: 998,
      dateTime: scheduledTime,
      title: "تنبيه مجدول تجريبي ($seconds ثانية) ⏰",
      body:
          "الحمد لله.. موعد الأذان التجريبي! صوت المؤذن: ${azanPrefs.selectedVoice.title}",
      payload: "test_scheduled_${seconds}s",
      notificationDetails: LocalNotificationService.getAzanNotificationDetails(
          azanPrefs.selectedVoice),
    );
    return canExact;
  }

  Future<void> syncSchedules(NotificationSettingsModel settings) async {
    try {
      await _notificationService.cancelAll();

      if (!settings.allNotificationsEnabled) {
        debugPrint(
            "NotificationSchedulerService: All notifications are disabled by user.");
        return;
      }

      try {
        await _schedulePrayers(settings);
      } catch (e, s) {
        debugPrint(
            "NotificationSchedulerService: Failed to schedule prayers: $e\n$s");
      }

      try {
        await _scheduleAzkar(settings);
      } catch (e, s) {
        debugPrint(
            "NotificationSchedulerService: Failed to schedule azkar: $e\n$s");
      }

      try {
        await _scheduleDailyReminders(settings);
      } catch (e, s) {
        debugPrint(
            "NotificationSchedulerService: Failed to schedule daily reminders: $e\n$s");
      }

      try {
        await _scheduleSunan(settings);
      } catch (e, s) {
        debugPrint(
            "NotificationSchedulerService: Failed to schedule sunan: $e\n$s");
      }

      try {
        await _scheduleOccasions(settings);
      } catch (e, s) {
        debugPrint(
            "NotificationSchedulerService: Failed to schedule occasions: $e\n$s");
      }

      debugPrint(
          "NotificationSchedulerService: Notification schedules synced successfully.");
    } catch (e, stack) {
      debugPrint(
          "NotificationSchedulerService: Error syncing notification schedules: $e\n$stack");
    }
  }

  Future<void> _schedulePrayers(NotificationSettingsModel settings) async {
    if (!settings.prayerNotificationsEnabled) return;

    AzanNotificationPreferences azanPrefs;
    try {
      azanPrefs = await _azanSettingsRepository.getPreferences();
    } catch (_) {
      azanPrefs = const AzanNotificationPreferences();
    }

    if (!azanPrefs.isEnabled) {
      debugPrint(
          "NotificationSchedulerService: Azan master switch is disabled.");
      return;
    }

    double lat = 30.0444;
    double lng = 31.2357;
    try {
      final cached = await _azanRepository.getCachedAzan();
      final prefs = await SharedPreferences.getInstance();
      lat = prefs.getDouble('cached_azan_lat') ?? 30.0444;
      lng = prefs.getDouble('cached_azan_lng') ?? 31.2357;
      if (cached == null) {
        _azanRepository.getInitialAzan();
      }
    } catch (_) {}

    final coordinates = Coordinates(lat, lng);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;

    int totalMinutes = azanPrefs.minuteAdjustment;
    if (azanPrefs.daylightSavingMode == DaylightSavingMode.summer) {
      totalMinutes += 60;
    }

    DateTime adjust(DateTime dt) {
      if (totalMinutes == 0) return dt;
      return dt.add(Duration(minutes: totalMinutes));
    }

    final now = DateTime.now();

    for (int dayOffset = 0; dayOffset < daysToSchedule; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      final dateComponents = DateComponents.from(targetDate);
      final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

      final fajrTime = adjust(prayerTimes.fajr);
      final dhuhrTime = adjust(prayerTimes.dhuhr);
      final asrTime = adjust(prayerTimes.asr);
      final maghribTime = adjust(prayerTimes.maghrib);
      final ishaTime = adjust(prayerTimes.isha);

      final idOffset = dayOffset * dayOffsetMultiplier;

      final prayers = [
        _PrayerScheduleItem(
          id: idFajr + idOffset,
          preId: idFajrPre + idOffset,
          name: "الفجر",
          time: fajrTime,
          isEnabled: settings.fajr && azanPrefs.fajr,
        ),
        _PrayerScheduleItem(
          id: idDhuhr + idOffset,
          preId: idDhuhrPre + idOffset,
          name: "الظهر",
          time: dhuhrTime,
          isEnabled: settings.dhuhr && azanPrefs.dhuhr,
        ),
        _PrayerScheduleItem(
          id: idAsr + idOffset,
          preId: idAsrPre + idOffset,
          name: "العصر",
          time: asrTime,
          isEnabled: settings.asr && azanPrefs.asr,
        ),
        _PrayerScheduleItem(
          id: idMaghrib + idOffset,
          preId: idMaghribPre + idOffset,
          name: "المغرب",
          time: maghribTime,
          isEnabled: settings.maghrib && azanPrefs.maghrib,
        ),
        _PrayerScheduleItem(
          id: idIsha + idOffset,
          preId: idIshaPre + idOffset,
          name: "العشاء",
          time: ishaTime,
          isEnabled: settings.isha && azanPrefs.isha,
        ),
      ];

      for (final prayer in prayers) {
        if (prayer.isEnabled && prayer.time != null) {
          await _notificationService.scheduleAzanNotification(
            id: prayer.id,
            dateTime: prayer.time!,
            title: "حان الآن موعد صلاة ${prayer.name} 🕌",
            body: "حي على الصلاة، حي على الفلاح.. أقم صلاتك تنعم بحياتك.",
            voice: azanPrefs.selectedVoice,
            payload: "prayer_${prayer.name}",
          );

          if (settings.prayerPreReminder) {
            final preTime = prayer.time!.subtract(const Duration(minutes: 10));
            await _notificationService.scheduleNotification(
              id: prayer.preId,
              dateTime: preTime,
              title: "اقترب موعد صلاة ${prayer.name} ⏳",
              body: "متبقي 10 دقائق على أذان ${prayer.name}.. تهيأ وتوضأ.",
              payload: "pre_prayer_${prayer.name}",
            );
          }
        }
      }
    }
  }

  Future<void> _scheduleAzkar(NotificationSettingsModel settings) async {
    if (!settings.azkarNotificationsEnabled) return;

    final now = DateTime.now();

    for (int dayOffset = 0; dayOffset < daysToSchedule; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      final idOffset = dayOffset * dayOffsetMultiplier;

      if (settings.morningAzkar) {
        await _notificationService.scheduleNotification(
          id: idMorningAzkar + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 7, 0),
          title: "أذكار الصباح ☀️",
          body: "أصبحنا وأصبح الملك لله.. ابدأ يومك بذكر الله وتوكل عليه.",
          payload: "0",
        );
      }

      if (settings.eveningAzkar) {
        await _notificationService.scheduleNotification(
          id: idEveningAzkar + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 17, 0),
          title: "أذكار المساء 🌙",
          body: "أمسينا وأمسى الملك لله.. حصّن نفسك وعائلتك بورد المساء المبارك.",
          payload: "1",
        );
      }

      if (settings.sleepAzkar) {
        await _notificationService.scheduleNotification(
          id: idSleepAzkar + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 22, 30),
          title: "أذكار النوم والسكينة 🛏️",
          body:
              "باسمك ربي وضعت جنبي وبك أرفعه.. اختم يومك بذكر الله ونم مطمئناً.",
          payload: "sleep",
        );
      }

      if (settings.wakeUpAzkar) {
        await _notificationService.scheduleNotification(
          id: idWakeUpAzkar + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 6, 0),
          title: "أذكار الاستيقاظ من النوم 🌤️",
          body: "الحمد لله الذي أحيانا بعد ما أماتنا وإليه النشور.",
          payload: "wakeup",
        );
      }
    }
  }

  Future<void> _scheduleDailyReminders(
      NotificationSettingsModel settings) async {
    final now = DateTime.now();

    for (int dayOffset = 0; dayOffset < daysToSchedule; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      final idOffset = dayOffset * dayOffsetMultiplier;

      if (settings.dailyZekrEnabled) {
        await _notificationService.scheduleNotification(
          id: idDailyZekr + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 9, 0),
          title: "ذكر اليوم المبارك 🌿",
          body:
              "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.",
          payload: "daily_zekr",
        );
      }

      if (settings.dailyHadithEnabled) {
        await _notificationService.scheduleNotification(
          id: idDailyHadith + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 13, 30),
          title: "قبس من الهدي النبوي 📖",
          body:
              "قال ﷺ: «كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم».",
          payload: "daily_hadith",
        );
      }
    }
  }

  Future<void> _scheduleSunan(NotificationSettingsModel settings) async {
    if (!settings.sunanEnabled) return;

    final now = DateTime.now();

    for (int dayOffset = 0; dayOffset < daysToSchedule; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      final idOffset = dayOffset * dayOffsetMultiplier;

      if (settings.duhaPrayer) {
        await _notificationService.scheduleNotification(
          id: idDuha + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 9, 30),
          title: "صلاة الضحى (صلاة الأوابين) ☀️",
          body:
              "ركعتا الضحى تُجزئان عن صدقة مفاصل الجسد (صلاة الأوابين).. لا تفوت أجرها العظيم.",
          payload: "duha",
        );
      }

      if (settings.qiyamNight) {
        await _notificationService.scheduleNotification(
          id: idQiyam + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 3, 30),
          title: "قيام الليل والوتر 🌌",
          body:
              "ينزل ربنا تبارك وتعالى كل ليلة إلى السماء الدنيا حين يبقى ثلث الليل الآخر فيقول: هل من سائل يُعطى؟ أوتِر ولو بركعة.",
          payload: "qiyam",
        );
      }
    }
  }

  Future<void> _scheduleOccasions(NotificationSettingsModel settings) async {
    if (!settings.occasionsEnabled) return;

    final now = DateTime.now();

    for (int dayOffset = 0; dayOffset < daysToSchedule; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      final idOffset = dayOffset * dayOffsetMultiplier;

      if (settings.fridayKahf && targetDate.weekday == DateTime.friday) {
        await _notificationService.scheduleNotification(
          id: idFridayKahf + idOffset,
          dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 8, 30),
          title: "يوم الجمعة المبارك 🕌",
          body:
              "نورٌ ما بين الجمعتين.. لا تنسَ قراءة سورة الكهف والإكثار من الصلاة على الحبيب ﷺ.",
          payload: "friday_kahf",
        );
      }

      if (settings.fastingMondayThursday) {
        if (targetDate.weekday == DateTime.sunday) {
          await _notificationService.scheduleNotification(
            id: idFastingMonday + idOffset,
            dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 20, 30),
            title: "سنة صيام الإثنين 🌸",
            body: "غداً الإثنين، تُعرض فيه الأعمال على الله.. فكن من الصائمين.",
            payload: "fasting_monday",
          );
        }

        if (targetDate.weekday == DateTime.wednesday) {
          await _notificationService.scheduleNotification(
            id: idFastingThursday + idOffset,
            dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 20, 30),
            title: "سنة صيام الخميس 🌸",
            body: "غداً الخميس، تُعرض فيه الأعمال على الله.. فكن من الصائمين.",
            payload: "fasting_thursday",
          );
        }
      }

      if (settings.fastingWhiteDays) {
        final hijri = HijriCalendar.fromDate(targetDate);
        if (hijri.hDay == 12) {
          await _notificationService.scheduleNotification(
            id: idFastingWhiteDays + idOffset,
            dateTime: DateTime(targetDate.year, targetDate.month, targetDate.day, 20, 30),
            title: "صيام الأيام البيض 🌕",
            body:
                "غداً بداية الأيام البيض (13، 14، 15) من الشهر الهجري.. صمها تُكتب لك صدقة عظيمة.",
            payload: "fasting_white_days",
          );
        }
      }
    }
  }
}

class _PrayerScheduleItem {
  final int id;
  final int preId;
  final String name;
  final DateTime? time;
  final bool isEnabled;

  _PrayerScheduleItem({
    required this.id,
    required this.preId,
    required this.name,
    required this.time,
    required this.isEnabled,
  });
}
